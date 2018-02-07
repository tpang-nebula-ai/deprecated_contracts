pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";
import "../interface/Client_Interface_dispatcher.sol";
import "../interface/Queue_Interface.sol";
import "../interface/Dispatcher_Interface_client.sol";
import "../interface/Dispatcher_Interface_miner.sol";
import "../interface/Dispatcher_Interface_distributor.sol";


contract Dispatcher is Ownable, DispatcherInterfaceClient, DispatcherInterfaceMiner, DispatcherInterfaceDistributor
{
    address public task_pool_address;
    address public queue_ai_address;
    address public queue_task_address;
    address public client_info_address;

    ClientInterfaceNebula client_info_contract;
    //    TaskPoolInterface task_pool_contract;
    QueueInterface queue_ai_contract;
    QueueInterface queue_task_contract;

    function Dispatcher(address _task_pool, address _queue_ai, address _queue_task, address _client)
    public
    Ownable(msg.sender)
    {
        require(_task_pool != address(0) && _queue_task != address(0) && _queue_ai != address(0) && _client != address(0));
        task_pool_address = _task_pool;
        client_info_address = _client;
        queue_ai_address = _queue_ai;
        queue_task_address = _queue_task;

        //Load corresponding contracts
        client_info_contract = ClientInterfaceNebula(client_info_address);
        //        task_pool_contract = TaskInterface(task_pool_address);
        queue_ai_contract = QueueInterface(queue_ai_address);
        queue_task_contract = QueueInterface(queue_task_address);
    }

    modifier contract_ready(){
        //require();
        _;
    }

}
