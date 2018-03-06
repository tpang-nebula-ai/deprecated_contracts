pragma solidity ^0.4.18;

interface DispatcherInterfaceSubmitter {
    function task_position(address _task) view external returns (uint256);

    function ai_queue_length() view external returns (uint256);

    function task_queue_length() view external returns (uint256);
}