pragma solidity ^0.4.18;

interface TaskPoolInterfaceAdmin {
    function set_distributor(address _distributor) public returns (bool);
}
