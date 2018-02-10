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

//Dispatcher Logic Module
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

    address public taskpool_address;  //Not needed 
    TaskPoolInterfaceGetter taskpool; //Not needed

    address public distributor_address;
    DistributorInterfaceDispatcher distributor;

    //------------------------------------------------------------------------------------------------------------------
    //Constructor
    function Dispatcher() public Ownable(msg.sender) {}

    //------------------------------------------------------------------------------------------------------------------
    //Modifier
    modifier Ready(){
        require(ready);
        _;
    }

    //------------------------------------------------------------------------------------------------------------------
    //Setters
    ///@dev Owner setter for contract preparation
    function set_client(address _client) ownerOnly public returns (bool){
        require(_client != address(0));
        client_address = _client;
        client = ClientInterfaceDispatcher(client_address);
        return ready_check();
    }
    ///@dev Owner setter for contract preparation
    function set_ai_queue(address _queue_ai) ownerOnly public returns (bool){
        require(_queue_ai != address(0));
        queue_ai_address = _queue_ai;
        queue_ai = QueueInterface(queue_ai_address);
        return ready_check();
    }
    ///@dev Owner setter for contract preparation
    function set_task_queue(address _queue_task) ownerOnly public returns (bool){
        require(_queue_task != address(0));
        queue_task_address = _queue_task;
        queue_task = QueueInterface(queue_task_address);
        return ready_check();
    }
    ///@dev Owner setter for contract preparation
    function set_taskpool(address _taskpool) ownerOnly public returns (bool){
        require(_taskpool != address(0));
        taskpool_address = _taskpool;
        taskpool = TaskPoolInterfaceGetter(taskpool_address);
        return ready_check();
    }
    //@dev Owner setter for contract preparation
    function set_distributor(address _distributor) ownerOnly public returns (bool){
        require(_distributor != address(0));
        distributor_address = _distributor;
        distributor = DistributorInterfaceDispatcher(distributor_address);
        return ready_check();
    }

    //------------------------------------------------------------------------------------------------------------------
    //internal helpers
    ///@dev internal usage
    function ready_check() internal returns (bool){
        return ready = client_address != address(0) && queue_ai_address != address(0) && queue_task_address != address(0)
        && taskpool_address != address(0) && distributor_address != address(0);
    }
    ///@dev internal usage
    struct account_info {
        bool _eligible;
        bool _waiting;
        bool _working;
        bool _banned;
        uint8 _misconduct_counter;
        uint8 _level;
        bool _submissible;
    }
    
    //@dev internal usage
    function load_client(address _client) Ready view internal returns (account_info){
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
    //@dev internal usage
    function calculate_position(bool _is_task, address _address) Ready internal view returns (uint256){
        uint _id;
        uint _curr;
        (, , _id, _curr) = _is_task ? queue_task.queuer_status(_address) : queue_ai.queuer_status(_address);
        return _id <= _curr ? 0 : _id.sub(_curr);
    }
    /**
     * @dev internal usage, make change in its own data contract
     * 
     * @param _is_task distinguish a task or worker address
     * @param _address the address of the task or worker
     * @return @param _success whether the pushing to queue is successful
     *         @param _dispatchable whether a task can be dispatched to a worker
     *         @param _worker address of the worker where the task is assigned to
     *         @param _task address of the task to be dispatched to worker
     */
    function is_dispatchable(bool _is_task, address _address)
    Ready internal
    returns (bool _success, bool _dispatchable, address _worker, address _task){
        if(_is_task){
            if(queue_ai.size() == 0) return (queue_task.push(_address), false, address(0), address(0));
            else{
                if(queue_task.size() == 0) return (true, true, queue_ai.pop(), _address);
                else return (queue_task.push(_address), true, queue_ai.pop(), queue_task.pop());
            }
        }else{
            if(queue_task.size() == 0) {
                client.set_waiting(_address, true);//set waiting
                return (queue_ai.push(_address), false, address(0), address(0));
            }
            else{
                if(queue_ai.size() == 0) return (true, true, _address, queue_task.pop());
                else {
                    client.set_waiting(_address, true);// set waiting
                    return (queue_ai.push(_address), true, queue_ai.pop(), queue_task.pop());
                }
            }
        }
    }
    ///@dev internal usage, make changes in client accounts and task pool
    ///@dev task and client validation is made at their entry point
    function dispatch(address _task, address _worker) Ready internal returns (bool){
        //Client
        client.add_job(_worker, true, _task);//set to working
        //Task
        distributor.dispatch_task(_task, _worker);//change task status to dispatched
    }

    //------------------------------------------------------------------------------------------------------------------
    //Client
    ///@dev getter
    function task_position(address _task) Ready view public returns (uint256){
        return calculate_position(true, _task);
    }
    //@dev getter
    function task_queue_length() Ready view public returns (uint256){
        return queue_task.size();
    }

    //------------------------------------------------------------------------------------------------------------------
    //Miner
    ///@dev entry point
    function apply_eligibility() Ready public returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(!_sender._banned && !_sender._eligible);
        client.set_eligible(msg.sender, true);
    }
    ///@dev entry point: AI eligibility is checked here
    function join_ai_queue() Ready public returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(_sender._eligible && !_sender._waiting && !_sender._working);

        //make changes in both queue
        bool _success;
        bool _dispatchable;
        address _worker;
        address _task;
        (_success, _dispatchable, _worker, _task) = is_dispatchable(false, msg.sender);

        assert(_success);
        //make change in client account and task pool through Client and Distributor
    
        if(_dispatchable) dispatch(_task, _worker);
        
        return true;
    }
    ///@dev entry point
    function leave_ai_queue() Ready public returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(_sender._waiting);
        client.set_waiting(msg.sender, false);
    }
    ///@dev getter
    function ai_queue_length() Ready view public returns (uint256){
        return queue_ai.size();
    }
    ///@dev getter
    function ai_position(address _worker) Ready view public returns (uint256){
        return calculate_position(false, _worker);
    }

    //------------------------------------------------------------------------------------------------------------------
    //Distributor
    //@dev intermediate point - task validation has been made by
    function join_task_queue(address _task) Ready public payable returns (bool){
        client.add_task(msg.sender, true, _task);
        bool _success;
        bool _dispatchable;
        address _worker;
        (_success, _dispatchable, _worker, _task) = is_dispatchable(true, _task);

        assert(_success);
        if(_dispatchable) dispatch(_task, _worker);
        return true;
    }
    //@dev intermediate point, condition checked and met in distributor
    function leave_task_queue(address _task_address) Ready public returns (bool){
        assert(queue_task.remove(_task_address));
        return true;
    }
    //@dev task rejoin to queue after being dispatched
    //@dev intermediate point
    function rejoin(address _task, address _worker, uint _penalty) Ready public returns (bool){
        queue_task.insert(_task, 0);//current insert to head of the queue_task
        return client.set_misconduct_counter(_worker, true, _penalty);
    }
}
