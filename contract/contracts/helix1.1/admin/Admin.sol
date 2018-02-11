pragma solidity ^0.4.18;



import "../ownership/Ownable.sol";

contract Admin is Ownable {
    address public dispatcher_address;
    address public client_address;
    address public distributor_address;

    Client client;
    Dispatcher dispatcher;
    Distributor distributor;

    address public queue_ai_address;
    address public queue_task_address;
    address public account_address;
    address public taskpool_address;

    Queue queue_ai;
    Queue queue_task;
    Accounts account;
    TaskPool taskpool;

    uint160 taskpool_nonce = 0;
    uint256 minimal_fee = 0;

    function Deployer() Ownable(msg.sender) public {
    }

    function init() ownerOnly public {
        queue_ai = new Queue();
        queue_task = new Queue();
        account = new Accounts();
        taskpool = new TaskPool(taskpool_nonce);

        //     queue_ai_address = address(queue_ai);
        //     queue_task_address = address(queue_task);
        //     account_address = address(account);
        //     taskpool_address = address(taskpool);

        // client = new Client();
        // dispatcher = new Dispatcher();
        // distributor = new Distributor(minimal_fee);

        // client_address = address(client);
        // dispatcher_address = address(dispatcher_address);
        // distributor_address = address(distributor);
    }
}
