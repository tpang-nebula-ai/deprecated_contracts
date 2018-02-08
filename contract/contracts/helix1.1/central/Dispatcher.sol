pragma solidity ^0.4.18;

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

    //------------------------------------------------------------------------------------------------------------------
    //Client
    function task_position(address _task) view public returns (uint256){
    queue_task.
    }




    //------------------------------------------------------------------------------------------------------------------
    //Miner
    function apply_eligibility() public returns (bool){

    }

    function join_ai_queue() public returns (bool){

    }

    function leave_ai_queue() public returns (bool){

    }

    //------------------------------------------------------------------------------------------------------------------
    //Distributor
    function join_task_queue(address _task) public payable returns (bool){

    }

    function leave_task_queue(address _task_address) public returns (bool){

    }
    //@dev task rejoin to queue after being dispatched
    function rejoin(address _task, address _worker, uint _penalty) public returns (bool){
        
    }


}
