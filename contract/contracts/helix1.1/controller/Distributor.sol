pragma solidity ^0.4.18;

// import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../ownership/Controllable.sol";
import "../misc/SafeMath.sol";

import "../interface/model/TaskPool_Interface.sol";

import "../interface/distributor/Distributor_Interface_submitter.sol";
import "../interface/distributor/Distributor_Interface_miner.sol";
import "../interface/distributor/Distributor_Interface_dispatcher.sol";
import "../interface/distributor/Distributor_Interface_client.sol";

import "../interface/dispatcher/Dispatcher_Interface_distributor.sol";
import "../interface/client/Client_Interface_distributor.sol";

//@dev used to access, store and modify ALL submitted task related functions
contract Distributor is Controllable,
DistributorInterfaceSubmitter, DistributorInterfaceMiner, DistributorInterfaceDispatcher, DistributorInterfaceClient {
    using SafeMath for uint256;
    using SafeMath for uint8;

    DispatcherInterfaceDistributor dispatcher;
    ClientInterfaceDistributor client;
    address public pool_address;
    TaskPoolInterface pool;

    uint256 public minimal_fee;

    function Distributor(address _admin, uint256 _minimal_fee) public Controllable(msg.sender, _admin) {
        minimal_fee = _minimal_fee;
    }

    //------------------------------------------------------------------------------------------------------------------
    //Admin
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model, address _task_queue) admin_only public returns (bool){
        super.set_addresses(_dispatcher, _distributor, _client, _model, _task_queue);
        
        pool_address = _model;
        pool = TaskPoolInterface(pool_address);

        client = ClientInterfaceDistributor(client_address);
        dispatcher = DispatcherInterfaceDistributor(dispatcher_address);
        //todo add a checker function

        controller_ready = true;
        return true;
    }

    //------------------------------------------------------------------------------------------------------------------
    modifier task_owner_only(address _task){
        require(pool.get_owner(_task) == msg.sender);
        _;
    }
    //@dev this made sure that the _task exists
    modifier miner_only(address _task){
        require(pool.get_worker(_task) == msg.sender);
        _;
    }

    //------------------------------------------------------------------------------------------------------------------
    //Client
    ///@dev entry point
    function create_task(
        uint256 _app_id,
        string _name,
        string _data,
        string _script,
        string _output,
        string _params
    ) Ready public payable returns (address _task){
        require(msg.value >= minimal_fee);
        //require(app.valid_id(_app_id)) app_id needs to be valid
        require(_app_id != 0);
        //temp TODO a contract that keep tracks of the app id
        require(client.submissible(msg.sender));

        _task = pool.create(_app_id, _name, _data, _script, _output, _params, msg.value, msg.sender);
        assert(_task != address(0));
        assert(client.add_task(msg.sender, true, _task));
        assert(dispatcher.join_task_queue(_task));
        TaskCreated(msg.sender, _task);
        return _task;
    }

    event TaskCreated(address _client, address _task);

    //@dev entry point
    function cancel_task(address _task) Ready external returns (bool){
        require(msg.sender == pool.get_owner(_task));
        uint _create_time;
        uint _dispatch_time;
        (_create_time, _dispatch_time, ,,,) = pool.get_status(_task);

        require(_create_time != 0 && _dispatch_time == 0);
        //task existed and in queue (not dispatched) => can be cancelled
        assert(dispatcher.leave_task_queue(_task) && !client.add_task(msg.sender, false, _task));
        uint256 _fee;
        (_fee,) = pool.get_fees(_task);
        assert(pool.set_fee(_task, 0) == 0);
        assert(pool.set_cancel(_task));
        msg.sender.transfer(_fee);
        TaskCancelled(msg.sender, _task);
        return true;
    }
    //    event TaskLeftQueue(address _client, address _task);
    //    event SubmitterFreed(address _client);
    event TaskCancelled(address _client, address _task);

    ///@dev entry point
    function reassign_task_request(address _task) Ready task_owner_only(_task) external returns (bool){
        require(pool.reassignable(_task));
        assert(change_worker(_task, pool.get_worker(_task), msg.sender));
        TaskRejoinedQueue(_task);
        return true;
    }
    //@dev entry point
    function pay_completion_fee(address _task) task_owner_only(msg.sender) payable external returns (bool){
        uint256 _fee;
        (, _fee) = pool.get_fees(_task);
        require(_fee != 0 && msg.value == _fee);
        assert(pool.set_completion_fee(_task, 0) == 0);
        pool.get_worker(_task).transfer(msg.value);
        return true;
    }

    //------------------------------------------------------------------------------------------------------------------
    //Miner
    ///@dev entry point
    function report_start(address _task) miner_only(_task) public returns (bool){
        //task can be reported start at anytime, as long as the task does exist (checked by miner_only modifier)
        //this does not effect anything, other than reassignable()
        assert(pool.set_start(_task));
        TaskStarted(_task);
        return true;
    }
    event TaskStarted(address _task);

    ///@dev entry point
    function report_finish(address _task, uint256 _complete_fee) miner_only(_task) public returns (bool){
        //task can be reported complete at anytime, as long as the task does exist (checked by miner_only modifier)
        assert(pool.set_complete(_task, _complete_fee));
        assert(complete_procedure(_task, msg.sender));
        uint256 _fee;
        (_fee,) = pool.get_fees(_task);
        assert(pool.set_fee(_task, 0) == 0);
        msg.sender.transfer(_fee);
        TaskCompleted(_task);
        return true;
    }
    event TaskCompleted(address _task);
    //@dev entry point
    //Currently the penalty would be pay the 1/3 price...
    //task can be reported error at anytime, as long as the task does exist (checked by miner_only modifier)
    function report_error(address _task, string _error_msg) miner_only(_task) public returns (bool){
        uint256 _fee;
        (_fee,) = pool.get_fees(_task);
        assert(pool.set_error(_task, _error_msg) && complete_procedure(_task, msg.sender) && pool.set_fee(_task, 0) == 0);
        uint256 _to_worker = _fee.div(3);
        msg.sender.transfer(_to_worker);
        pool.get_owner(_task).transfer(_fee.sub(_to_worker));
        ErrorReported(_task);
        return true;
    }

    event ErrorReported(address _task);
    ///@dev entry point
    //task can be forfeited at anytime, as long as the task does exist (checked by miner_only modifier)
    function forfeit(address _task) miner_only(_task) public returns (bool){
        assert(change_worker(_task, msg.sender, pool.get_owner(_task)));
        TaskRejoinedQueue(_task);
        return true;
    }

    function change_worker(address _task, address _worker, address _owner) internal returns (bool){
        return pool.set_forfeit(_task) && !client.add_job(_worker, false, _task)
        && dispatcher.rejoin(_task) && client.pay_penalty(_worker, _owner);
    }
    event TaskRejoinedQueue(address _task);
    //todo update for task_list by app
    //Release submitter from its active task; list #add_task should return false, indicating success
    //Release miner from its active job ; #add_job should return false, indicating success
    function complete_procedure(address _task, address _worker) internal returns (bool){
        return !client.add_task(pool.get_owner(_task), false, _task) && !client.add_job(_worker, false, _task);
    }
    //------------------------------------------------------------------------------------------------------------------
    //Dispatcher
    ///@dev intermediate
    function dispatch_task(address _task, address _worker) dispatcher_only public returns (bool){
        return pool.set_dispatched(_task, _worker);
    }
}