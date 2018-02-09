pragma solidity ^0.4.18;

import "../misc/SafeMath.sol";
import "../ownership/Ownable.sol";
import "../interface/Client_Interface_dispatcher.sol";
import "../interface/Queue_Interface.sol";
import "../interface/TaskPool_Interface_getters.sol";
import "../interface/Distributor_Interface_dispatcher.sol";
import "../interface/Dispatcher_Interface_client.sol";
import "../interface/Dispatcher_Interface_miner.sol";
import "../interface/Dispatcher_Interface_distributor.sol";

contract Dispatcher is Ownable, DispatcherInterfaceClient, DispatcherInterfaceMiner, DispatcherInterfaceDistributor
{
    //------------------------------------------------------------------------------------------------------------------
    using SafeMath for uint256;
    //Required Contracts
    bool public ready;

    address public client_address;
    ClientInterfaceDispatcher client;

    address public queue_ai_address;
    QueueInterface queue_ai;

    address public queue_task_address;
    QueueInterface queue_task;

    address public taskpool_address;
    TaskPoolInterfaceGetter taskpool;

    address public distributor_address;
    DistributorInterfaceDispatcher distributor;



    //------------------------------------------------------------------------------------------------------------------
    //Constructor
    function Dispatcher()
    public
    Ownable(msg.sender)
    {}

    //------------------------------------------------------------------------------------------------------------------
    //Modifier
    modifier Ready(){
        require(ready);
        _;
    }

    //------------------------------------------------------------------------------------------------------------------
    //Setters
    function set_client(address _client)
    ownerOnly
    public
    returns (bool)
    {
        require(_client != address(0));
        client_address = _client;
        client = ClientInterfaceDispatcher(client_address);
        return ready_check();
    }

    function set_ai_queue(address _queue_ai) ownerOnly public returns (bool){
        require(_queue_ai != address(0));
        queue_ai_address = _queue_ai;
        queue_ai = QueueInterface(queue_ai_address);
        return ready_check();
    }

    function set_task_queue(address _queue_task) ownerOnly public returns (bool){
        require(_queue_task != address(0));
        queue_task_address = _queue_task;
        queue_task = QueueInterface(queue_task_address);
        return ready_check();
    }

    function set_taskpool(address _taskpool) ownerOnly public returns (bool){
        require(_taskpool != address(0));
        taskpool_address = _taskpool;
        taskpool = TaskPoolInterfaceGetter(taskpool_address);
        return ready_check();
    }

    function set_distributor(address _distributor) ownerOnly public returns (bool){
        require(_distributor != address(0));
        distributor_address = _distributor;
        distributor = DistributorInterfaceDispatcher(distributor_address);
        return ready_check();
    }

    //------------------------------------------------------------------------------------------------------------------
    //internal helpers
    function ready_check() internal returns (bool){
        return ready = client_address != address(0) && queue_ai_address != address(0) && queue_task_address != address(0)
        && taskpool_address != address(0) && distributor_address != address(0);
    }

    struct account_info {
        bool _eligible;
        bool _waiting;
        bool _working;
        bool _banned;
        uint8 _misconduct_counter;
        uint8 _level;
        bool _submissible;
    }

    function load_client(address _client) view internal returns (account_info){
        bool _eligible;
        bool _waiting;
        bool _working;
        bool _banned;
        uint8 _misconduct_counter;
        uint8 _level;
        bool _submissible;
        (_eligible, _waiting, _working, _banned, _misconduct_counter, _level, _submissible) = client.get_client(_client);
        return account_info(_eligible, _waiting, _working, _banned, _misconduct_counter, _level, _submissible);
    }

    function calculate_position(bool _is_task, address _address) internal view returns (uint256){
        uint _id;
        uint _curr;
        (, ,_id, _curr) = _is_task ? queue_task.queuer_status(_address) : queue_ai.queuer_status(_address);
        return _id <= _curr ? 0 : _id.sub(_curr);
    }

    function dispatchable(bool _is_task) view internal returns (bool){
        return _is_task
        ? queue_task.size() == 0 && queue_ai.size() != 0
        : queue_ai.size() == 0 && queue_task.size() != 0;
    }

    function dispatch(address _task, address _worker) internal returns (bool){
        //Client
        client.add_job(_worker, true, _task);
        //Task
        distributor.dispatch_task(_task, _worker);
    }

    //------------------------------------------------------------------------------------------------------------------
    //Client
    function task_position(address _task) Ready view public returns (uint256){
        return calculate_position(true, _task);
    }

    function task_queue_length() Ready view public returns (uint256){
        return queue_task.size();
    }

    //------------------------------------------------------------------------------------------------------------------
    //Miner

    function apply_eligibility() Ready public returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(!_sender._banned && !_sender._eligible);
        client.set_eligible(msg.sender, true);
    }

    function join_ai_queue() Ready public returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(_sender._eligible && !_sender._waiting && !_sender._working);

        if (dispatchable(false)) {
            dispatch(queue_task.pop(), msg.sender);
        } else {
            client.set_waiting(msg.sender, true);
        }
    }

    function leave_ai_queue() Ready public returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(_sender._waiting);
        client.set_waiting(msg.sender, false);
    }

    function ai_queue_length() Ready view public returns (uint256){
        return queue_ai.size();
    }

    function ai_position(address _worker) Ready view public returns (uint256){
        return calculate_position(false, _worker);
    }

    //------------------------------------------------------------------------------------------------------------------
    //Distributor
    function join_task_queue(address _task) Ready public payable returns (bool){
        
    }

    function leave_task_queue(address _task_address) Ready public returns (bool){

    }
    //@dev task rejoin to queue after being dispatched
    function rejoin(address _task, address _worker, uint _penalty) Ready public returns (bool){
        
    }


}
