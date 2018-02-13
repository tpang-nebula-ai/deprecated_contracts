pragma solidity ^0.4.18;

interface QueueInterfaceAdmin {
    function set_dispatcher(address _dispatcher) public returns (bool);
}
