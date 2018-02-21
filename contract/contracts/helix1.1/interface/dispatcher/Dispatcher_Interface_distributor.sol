pragma solidity ^0.4.18;

interface DispatcherInterfaceDistributor {

    function join_task_queue(address _task) external payable returns (bool);

    function leave_task_queue(address _task_address) external returns (bool);

    function rejoin(address _task, uint8 _position) external returns (bool);
}
