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
    function set_addresses(
        address _dispatcher, address _distributor, address _client, address _model, address _task_queue)
    admin_only public returns (bool){
        super.set_addresses(_dispatcher, _distributor, _client, _model, _task_queue);

        queue_ai_address = _model;
        queue_ai = QueueInterface(queue_ai_address);
        queue_task_address = _task_queue;
        queue_task = QueueInterface(queue_task_address);

        client = ClientInterfaceDispatcher(client_address);
        distributor = DistributorInterfaceDispatcher(distributor_address);
        controller_ready = true;
        return true;
    }

    function() public {

    }
    
    //------------------------------------------------------------------------------------------------------------------
    //internal helpers

    ///@dev internal usage
    struct account_info {
        bool _eligible;
        bool _waiting;
        bool _working;
        bool _banned;
        uint8 _level;
        bool _submissible;
    }
    
    //@dev internal usage
    function load_client(address _client) Ready view internal returns (account_info){
        bool _eligible;
        bool _waiting;
        bool _working;
        bool _banned;
        uint8 _level;
        bool _submissible;
        (_eligible, _waiting, _working, _banned, , _level, _submissible) = client.get_client(_client);
        return account_info(_eligible, _waiting, _working, _banned, _level, _submissible);
    }
    //@dev internal usage, if a task/ai get dispatched immediately and did not join queue, this still holds,
    // as soon as
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
     * @return true if the entire process is completed
     */
    function dispatch_or_join(bool _is_task, address _address) public Ready returns (bool){
        bool _dispatchable;
        address _worker;
        address _dispatchable_task;

        if(_is_task){
            if (queue_ai.size() == 0) {
                assert(queue_task.push(_address));
            } else {
                assert((_worker = queue_ai.pop()) != address(0));
                if (queue_task.size() == 0) {
                    _dispatchable_task = _address;
                } else {
                    assert(queue_task.push(_address));
                    assert((_dispatchable_task = queue_task.pop()) != address(0));
                }
                _dispatchable = true;
            }
        } else {
            if (queue_task.size() == 0) {
                assert(queue_ai.push(_address));
            } else {
                assert((_dispatchable_task = queue_task.pop()) != address(0));
                if (queue_ai.size() == 0) {
                    _worker = _address;
                }
                else {
                    assert(queue_ai.push(_address));
                    assert((_worker = queue_ai.pop()) != address(0));
                }
                _dispatchable = true;
            }
        }
        if (_dispatchable) {
            assert(client.add_job(_worker, true, _dispatchable_task));
            assert(distributor.dispatch_task(_dispatchable_task, _worker));
            TaskDispatched(_dispatchable_task, _worker);
        }else{
            _is_task ? TaskQueued(_address) : AiQueued(_address);
        }
        return true;
    }

    event TaskDispatched(address _task, address _worker);
    event TaskQueued(address _task);
    event AiQueued(address _miner);

    //------------------------------------------------------------------------------------------------------------------
    //Miner
    ///@dev entry point: AI eligibility is checked here
    function join_ai_queue() external Ready returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(_sender._eligible && !_sender._waiting && !_sender._working);

        assert(client.set_waiting(msg.sender, true));
        assert(dispatch_or_join(false, msg.sender));
        return true;
    }
    ///@dev entry point
    //require sender waiting -> no checker needed
    function leave_ai_queue() external Ready returns (bool){
        account_info memory _sender = load_client(msg.sender);
        require(_sender._waiting && !_sender._working);

        assert(queue_ai.remove(msg.sender));
        //if not existed, Queue#remove return false
        assert(!client.set_waiting(msg.sender, false));
        AiLeftQueue(msg.sender);
        return true;
    }
    event AiLeftQueue(address _worker);
    ///@dev getter
    function ai_queue_length() external Ready view returns (uint256){
        return queue_ai.size();
    }
    ///@dev getter
    function ai_position(address _worker) external Ready view returns (uint256){
        return calculate_position(false, _worker);
    }

    //------------------------------------------------------------------------------------------------------------------
    //Distributor
    //@dev intermediate point - task validation has been made by
    function join_task_queue(address _task) external Ready distributor_only payable returns (bool){
        assert(dispatch_or_join(true, _task));
        return true;
    }
    //@dev intermediate point, condition checked and met in distributor
    function leave_task_queue(address _task_address) external Ready distributor_only returns (bool){
        assert(queue_task.remove(_task_address));
        return true;
    }
    //@dev task rejoin to queue after being dispatched
    //@dev intermediate point
    //current insert to head of the queue_task
    function rejoin(address _task) external Ready distributor_only returns (bool){
        require(1 > 2);
        assert(queue_task.insert(_task, 0));
        assert(dispatch_or_join(true, 0));
        //todo this is not completed yet
        return false;
    }
    ///@dev getter
    function task_position(address _task) external view Ready returns (uint256){
        return calculate_position(true, _task);
    }
    //@dev getter
    function task_queue_length() external view Ready returns (uint256){
        return queue_task.size();
    }
}
