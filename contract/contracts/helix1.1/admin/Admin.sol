pragma solidity ^0.4.18;
import "../ownership/Ownable.sol";
import "../interface/controller/Controller_Interface_admin.sol";
import "../model/account/Account_Interface_admin.sol";
import "../model/queue/Queue_Interface_admin.sol";
import "../model/taskpool/TaskPool_Interface_admin.sol";

contract Admin is Ownable {

    address public dispatcher_address;
    address public client_address;
    address public distributor_address;

    ControllerInterfaceAdmin dispatcher;
    ControllerInterfaceAdmin distributor;
    ControllerInterfaceAdmin client;


    address public queue_ai_address;
    address public queue_task_address;
    address public account_address;
    address public taskpool_address;

    AccountInterfaceAdmin account;
    QueueInterfaceAdmin queue_ai;
    QueueInterfaceAdmin queue_task;
    TaskPoolInterfaceAdmin taskpool;

    function Admin() Ownable(msg.sender) public {}

    modifier valid_address(address _address){
        require(_address != address(0));
        _;
    }
    //Setters-----------------------------------------------------------------------------------------------------------
    function set_dispatcher_address(address _address) valid_address(_address) ownerOnly public {
        dispatcher_address = _address;
        dispatcher = ControllerInterfaceAdmin(dispatcher_address);
    }

    function set_distributor_address(address _address) valid_address(_address) ownerOnly public {
        distributor_address = _address;
        distributor = ControllerInterfaceAdmin(distributor_address);
    }

    function set_client_address(address _address) valid_address(_address) ownerOnly public {
        client_address = _address;
        client = ControllerInterfaceAdmin(client_address);
    }

    function set_ai_queue_address(address _address) valid_address(_address) ownerOnly public {
        queue_ai_address = _address;
        queue_ai = QueueInterfaceAdmin(queue_ai_address);
    }

    function set_task_queue_address(address _address) valid_address(_address) ownerOnly public {
        queue_task_address = _address;
        queue_task = QueueInterfaceAdmin(queue_task_address);
    }

    function set_account_address(address _address) valid_address(_address) ownerOnly public {
        account_address = _address;
        account = AccountInterfaceAdmin(account_address);
    }

    function set_taskpool_address(address _address) valid_address(_address) ownerOnly public {
        taskpool_address = _address;
        taskpool = TaskPoolInterfaceAdmin(taskpool_address);
    }

    function set_all() ownerOnly public returns (bool){
        // require(dispatcher_address != address(0) && client_address != address(0) && distributor_address != address(0)
        // && queue_ai_address != address(0) && queue_task_address != address(0)
        // && account_address != address(0) && taskpool_address != address(0));

        set_distributor();
        set_dispatcher();
        set_client();

        set_account();
        set_queue_task();
        set_queue_ai();
        set_taskpool();
        return true;
    }

    function set_dispatcher() public returns (bool){
        return dispatcher.set_addresses(dispatcher_address, distributor_address, client_address, queue_ai_address, queue_task_address);
    }

    function set_distributor() public returns (bool){
        return distributor.set_addresses(dispatcher_address, distributor_address, client_address, taskpool_address, address(0));
    }

    function set_client() public returns (bool){
        return client.set_addresses(dispatcher_address, distributor_address, client_address, account_address, address(0));
    }

    function set_account() public returns (bool){
        return account.set_client(client_address);
    }

    function set_queue_ai() public returns (bool){
        return queue_ai.set_dispatcher(dispatcher_address);
    }

    function set_queue_task() public returns (bool){
        return queue_task.set_dispatcher(dispatcher_address);
    }

    function set_taskpool() public returns (bool){
        return taskpool.set_distributor(distributor_address);
    }
}









