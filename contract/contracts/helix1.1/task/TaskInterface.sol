pragma solidity ^0.4.18;

interface TaskInterface {
    //Internal
    function addTaskToQueue();

    //Task Owner
    function cancelTask() public returns (bool);

    event TaskCancelled();

    //Task Dispatcher
    function assignWorker(address _worker_address) public returns (bool);

    function startTask() public returns (bool);

    function reportIssue() public returns (bool);

    function forfeitTask() public returns (bool);

    function finishTask() public returns (bool);

    event WorkerAssigned(address indexed _worker_address);
    event TaskFailed();
    event TaskForfeited();
    event TaskCompleted();
}
