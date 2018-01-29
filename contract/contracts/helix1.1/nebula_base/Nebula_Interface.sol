pragma solidity 0.4.18;

contract Nebula_Interface {
    function join(address _task) public returns (bool);

    function leave(address _task_address) public returns (bool);

    function rejoin(address _task) public returns (bool);
}