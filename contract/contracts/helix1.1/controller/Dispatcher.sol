pragma solidity ^0.4.18;

import "../misc/SafeMath.sol";
import "../ownership/Controllable.sol";

import "../interface/model/Queue_Interface.sol";

import "../interface/dispatcher/Dispatcher_Interface_client.sol";
import "../interface/dispatcher/Dispatcher_Interface_distributor.sol";
import "../interface/dispatcher/Dispatcher_Interface_submitter.sol";
import "../interface/dispatcher/Dispatcher_Interface_miner.sol";

import "../interface/client/Client_Interface_dispatcher.sol";
import "../interface/distributor/Distributor_Interface_dispatcher.sol";

//Dispatcher Logic Module
contract Dispatcher is Controllable,
DispatcherInterfaceSubmitter, DispatcherInterfaceMiner, DispatcherInterfaceDistributor, DispatcherInterfaceClient
{
    //------------------------------------------------------------------------------------------------------------------
    using SafeMath for uint256;

    ClientInterfaceDispatcher client;
    DistributorInterfaceDispatcher distributor;

    address public queue_ai_address;
    QueueInterface queue_ai;

    address public queue_task_address;
    QueueInterface queue_task;


    //------------------------------------------------------------------------------------------------------------------
    //Constructor
    function Dispatcher(address _admin) public Controllable(msg.sender, _admin) {}

    //------------------------------------------------------------------------------------------------------------------
    //Modifier

    //------------------------------------------------------------------------------------------------------------------
    //Setters
    //Override
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model, address _task_queue) admin_only public returns (bool){
        super.set_addresses(_dispatcher, _distributor, _client, _model, _task_queue);

        queue_ai_address = _model;
        queue_ai = QueueInterface(queue_ai_address);
        queue_task_address = _task_queue;
        queue_task = QueueInterface(queue_task_address);

        client = ClientInterfaceDispatcher(client_address);
        distributor = DistributorInterfaceDispatcher(distributor_address);
        //todo add a checker function
       
        controller_ready = true;

        return true;
    }

    event B(address);
    event C(address);
    //------------------------------------------------------------------------------------------------------------------
    //internal helpers

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
            client.set_waiting(_address, true);
            //set waiting
            if (queue_task.size() == 0) return (queue_ai.push(_address), false, address(0), address(0));
            else{
                if(queue_ai.size() == 0) return (true, true, _address, queue_task.pop());
                else return (queue_ai.push(_address), true, queue_ai.pop(), queue_task.pop());
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
    //@dev task rejoin to queue after being dispatched @dev todo not completed
    //@dev intermediate point
    function rejoin(address _task, address _worker, uint8 _penalty) Ready public returns (uint8){
        queue_task.insert(_task, 0);//current insert to head of the queue_task
        return client.set_misconduct_counter(_worker, true, _penalty);
    }
}
