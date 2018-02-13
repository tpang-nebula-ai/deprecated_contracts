pragma solidity ^0.4.18;

interface DispatcherInterfaceSubmitter {
    function task_position(address _task) view public returns (uint256);
}