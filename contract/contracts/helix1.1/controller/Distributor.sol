pragma solidity ^0.4.18;

import "../misc/SafeMath.sol";
import "../ownership/Controllable.sol";

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
    uint256 public MAX_WAITING_BLOCK_COUNT = 15;

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
    modifier miner_only(address _task){
        require(pool.get_worker(_task) == msg.sender);
        _;
    }

    //------------------------------------------------------------------------------------------------------------------
    //Client
    ///@dev entry point
    //TODO condition checker should be added here, not in dispatcher
    function create_task(
        uint256 _app_id,
        string _name,
        string _data,
        string _script,
        string _output,
        string _params
    ) Ready public payable returns (address _task){
        //        require(app.valid_id(_app_id)) app_id needs to be valid , TODO a contract that keep tracks of the app id
        require(msg.value >= minimal_fee && _app_id != 0);
        _task = pool.create(_app_id, _name, _data, _script, _output, _params, msg.value, msg.sender);
        dispatcher.join_task_queue.value(msg.value)(_task);
        //TODO this ONLY for testing
    }

    //@dev entry point TODO REVIEW REQUIRED and add assert
    function cancel_task(address _task) Ready public returns (bool){
        address _task_owner = pool.get_owner(_task);
        require(msg.sender == _task_owner);
        uint _create_time;
        uint _dispatch_time;
        (_create_time, _dispatch_time, ,,,) = pool.get_status(_task);

        require(_create_time != 0);
        //task existed
        if (_dispatch_time == 0 && dispatcher.leave_task_queue(_task)) {
            //in queue can be cancelled
            uint256 _fee;
            (_fee,) = pool.get_fees(_task);
            assert(pool.set_fee(_task, 0));
            _task_owner.transfer(_fee);
            return true; 
        } else return false; //task dispatched cannot cancel
    }
    ///@dev entry point TODO verify checker
    function reassignable(address _task)
    Ready
    task_owner_only(_task)
    view
    public
    returns (bool){
        uint _create_time;
        uint _dispatch_time;
        (_create_time, _dispatch_time, ,,,) = pool.get_status(_task);
        require(_create_time != 0 && _dispatch_time != 0);
        return block.number - _dispatch_time > MAX_WAITING_BLOCK_COUNT;
    }
    ///@dev entry point TODO verify checker and change to assert
    function reassign_task_request(address _task)
    Ready
    task_owner_only(_task)
    public
    returns (bool)
    {
        if (reassignable(_task)) {
            uint8 _misconduct_counter;
            (, ,,, _misconduct_counter,,) = client.get_client(msg.sender);
            assert(dispatcher.rejoin(_task, msg.sender, uint8(2)) == _misconduct_counter.add(2));
            return true;
        }
    }

    //------------------------------------------------------------------------------------------------------------------
    //Miner
    ///@dev entry point TODO condition check
    function report_start(address _task) miner_only(_task) public returns (bool){
        assert(pool.set_start(_task));
        return true;
    }
    ///@dev entry point TODO condition check, change client and worker status
    function report_finish(address _task, uint256 _complete_fee) miner_only(_task) public returns (bool){
        assert(pool.set_complete(_task, _complete_fee) && set_complete(_task));
        return true;
    }
    ///@dev entry point TODO condition check , CHANGE Client and worker status
    ///Currently the penalty would be pay the full price...
    function report_error(address _task, string _error_msg) miner_only(_task) public returns (bool){
        assert(pool.set_error(_task, _error_msg) && set_complete(_task));
        return true;
    }
    ///@dev entry point TODO condition check, change miner status
    function forfeit(address _task) miner_only(_task) public returns (bool){
        uint8 _misconduct_counter;
        (, ,,, _misconduct_counter,,) = client.get_client(msg.sender);
        assert(pool.set_forfeit(_task) && dispatcher.rejoin(_task, msg.sender, uint8(1)) == _misconduct_counter.add(1) && set_complete(_task));
        return true;
    }
    // client. set miner free and owner free
    function set_complete(address _task) internal returns (bool){
        return client.add_task(pool.get_owner(_task), false, _task) == false //submitter
        && client.add_job(pool.get_worker(_task), false, _task) == false;
        //worker
    }

    //------------------------------------------------------------------------------------------------------------------
    //Dispatcher
    ///@dev intermediate
    function dispatch_task(address _task, address _worker) dispatcher_only public {
        pool.set_dispatched(_task, _worker);
    }

}