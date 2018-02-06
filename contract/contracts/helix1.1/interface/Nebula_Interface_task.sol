pragma solidity ^0.4.18;

interface NebulaInterfaceTask {

    function join(address _task) public payable returns (bool);

    function leave(address _task_address) public returns (bool);

    function rejoin(address _task) public returns (bool);
}
