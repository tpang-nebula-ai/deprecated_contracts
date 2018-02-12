pragma solidity ^0.4.18;

import "./Ownable.sol";
import "../interface/taskpool/TaskPool_Interface_admin.sol";

contract Distributable is Ownable, TaskPoolInterfaceAdmin {
    address public distributor_address;

    function Distributable(address _owner) public Ownable(_owner) {}

    modifier distributor_only(){
        require(distributor_address != address(0) && msg.sender == distributor_address);
        _;
    }

    function set_distributor(address _distributor) ownerOnly public returns (bool){
        require(_distributor != address(0));
        distributor_address = _distributor;
        return true;
    }
}
