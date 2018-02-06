pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";
import "../interface/Client_Interface.sol";
import "../interface/Task_Interface.sol";
import "../interface/Queue_Interface.sol";
import "../interface/Nebula_Interface_client.sol";
import "../interface/Nebula_Interface_miner.sol";
import "../interface/Nebula_Interface_task.sol";
import "../interface/Nebula_Interface_queue.sol";


contract Nebula
is Ownable, NebulaInterfaceClient, NebulaInterfaceMiner, NebulaInterfaceTask, NebulaInterfaceQueue
{
    address public task_pool_address;
    address public queue_ai_address;
    address public queue_task_address;
    address public client_info_address;
    
    ClientInterface client_info_contract;
    TaskInterface task_pool_contract;
    QueueInterface queue_ai_contract;
    QueueInterface queue_task_contract;

    function Nebula(address _task_pool, address _queue_ai, address _queue_task, address _client)
    public
    Ownable(msg.sender)
    {
        require(_task_pool != address(0) && _queue_task != address(0) && _queue_ai != address(0) && _client != address(0));
        task_pool_address = _task_pool;
        queue_ai_address = _queue_ai;
        queue_task_address = _queue_task;
        client_info_address = _client;

        //Load corresponding contracts
        client_info_contract = ClientInterface(client_info_address);
        task_pool_contract = TaskInterface(task_pool_address);
        queue_ai_contract = QueueInterface(queue_ai_address);
        queue_task_contract = QueueInterface(queue_task_address);
    }

    /**
     * NebulaInterfaceTask methods
     */
    function task_join(address _task) public payable returns (bool) {
        return true;
    }

    function task_leave(address _task_address) public returns (bool){
        return true;
    }

    function task_rejoin(address _task) public returns (bool){
        return true;
    }
    
    /**
     * NebulaInterfaceQueue methods (needed?)
     */
     
     
    /**
     * NebulaInterfaceClient methods
     */
    function submit_task(uint256 _app_id, bytes32 _name, string _data, string _script, string _output, string _params) public payable returns(address){
        return address(0);
    }

    function cancel_task(address _task_address) public returns(bool){
        return true;
    }
    /**
     * NebulaInterfaceMiner methods
     */ 
    function apply_eligibility() public returns(bool){
        return true;
    }

    function join_ai_queue() public returns(bool){
        return true;
    }

    function leave_ai_queue() public returns(bool){
        return true;
    }
    
    /**
     * ClientInterface methods
     */
     
    /**
     * TaskInterface methods
     */
    // function dispatchTask(address _worker_address) public returns (bool){
    //     return true;
    // }
    // function reassignTask(address _worker_address) public returns (bool){
    //     return true;
    // }
    
    /**
     * QueueInterface methods
     */ 
     
    

     
    

}
