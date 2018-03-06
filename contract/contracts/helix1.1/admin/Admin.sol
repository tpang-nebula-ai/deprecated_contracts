pragma solidity ^0.4.18;
import "../ownership/Ownable.sol";
import "../interface/controller/Controller_Interface_admin.sol";
import "../model/account/Account_Interface_admin.sol";
import "../model/queue/Queue_Interface_admin.sol";
import "../model/taskpool/TaskPool_Interface_admin.sol";

//@dev todo add version
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
    function set_all_addresses(
        address _dispatcher, address _distributor, address _client,
        address _ai_queue, address _task_queue,
        address _account, address _taskpool) ownerOnly public returns (bool){

        set_dispatcher_address(_dispatcher);
        set_distributor_address(_distributor);
        set_client_address(_client);
        set_ai_queue_address(_ai_queue);
        set_task_queue_address(_task_queue);
        set_account_address(_account);
        set_taskpool_address(_taskpool);
        AddressSet();
        assert(account_address == _account);
        return true;
    }

    event AddressSet();

    modifier setter(){
        require(msg.sender == owner);
        _;
    }

    function set_dispatcher_address(address _address) public valid_address(_address) setter {
        dispatcher_address = _address;
        dispatcher = ControllerInterfaceAdmin(dispatcher_address);
    }

    function set_distributor_address(address _address) public valid_address(_address) setter {
        distributor_address = _address;
        distributor = ControllerInterfaceAdmin(distributor_address);
    }

    function set_client_address(address _address) public valid_address(_address) setter {
        client_address = _address;
        client = ControllerInterfaceAdmin(client_address);
    }

    function set_ai_queue_address(address _address) public valid_address(_address) setter {
        queue_ai_address = _address;
        queue_ai = QueueInterfaceAdmin(queue_ai_address);
    }

    function set_task_queue_address(address _address) public valid_address(_address) setter {
        queue_task_address = _address;
        queue_task = QueueInterfaceAdmin(queue_task_address);
    }

    function set_account_address(address _address) public valid_address(_address) setter {
        account_address = _address;
        account = AccountInterfaceAdmin(account_address);
    }

    function set_taskpool_address(address _address) public valid_address(_address) setter {
        taskpool_address = _address;
        taskpool = TaskPoolInterfaceAdmin(taskpool_address);
    }

    function ready_to_set_all() public returns (bool){
        require(
            dispatcher_address != address(0) && client_address != address(0) && distributor_address != address(0)
            && queue_ai_address != address(0) && queue_task_address != address(0)
            && account_address != address(0) && taskpool_address != address(0)
        );
        return true;
    }
    //@dev entry point
    function set_all() public ownerOnly returns (bool){
        require(ready_to_set_all());
        assert(set_distributor() && set_dispatcher() && set_client()
        && set_account() && set_queue_task() && set_queue_ai() && set_taskpool());
        AddressesSetInAllContracts();
        return true;
    }

    event AddressesSetInAllContracts();
    //internals
    function set_dispatcher() internal returns (bool){
        return dispatcher.set_addresses(dispatcher_address, distributor_address, client_address, queue_ai_address, queue_task_address);
    }

    function set_distributor() internal returns (bool){
        return distributor.set_addresses(dispatcher_address, distributor_address, client_address, taskpool_address, address(0));
    }

    function set_client() internal returns (bool){
        return client.set_addresses(dispatcher_address, distributor_address, client_address, account_address, address(0));
    }

    function set_account() internal returns (bool){
        return account.set_client(client_address);
    }

    function set_queue_ai() internal returns (bool){
        return queue_ai.set_dispatcher(dispatcher_address);
    }

    function set_queue_task() internal returns (bool){
        return queue_task.set_dispatcher(dispatcher_address);
    }

    function set_taskpool() internal returns (bool){
        return taskpool.set_distributor(distributor_address);
    }

    ///@dev More administrator functions to be added
    function ban_client(address _client, bool _ban) owner_only public returns (bool){
        return account.set_banned(_client, _ban);
    }
    //    function remove_task();
    //    function remove_ai_from_queue();
    //    function close_task();
    //etc...
}