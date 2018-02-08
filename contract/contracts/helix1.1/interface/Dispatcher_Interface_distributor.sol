pragma solidity ^0.4.18;

interface DispatcherInterfaceDistributor {

    function queue(address _task) public payable returns (bool);

    function cancel(address _task_address) public returns (bool);

    function rejoin(address _task, address _worker, uint _penalty) public returns (bool);
}
