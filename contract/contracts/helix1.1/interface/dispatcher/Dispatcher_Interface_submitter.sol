pragma solidity ^0.4.18;

interface DispatcherInterfaceSubmitter {
    function task_position(address _task) view external returns (uint256);

    function ai_queue_length() view external returns (uint256);

    function task_queue_length() view external returns (uint256);

    event TaskDispatched(address indexed _task, address indexed _worker);
    event TaskQueued(address indexed _task);
    event AiQueued(address indexed _miner);
    event AiLeftQueue(address indexed _worker);
}