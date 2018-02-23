pragma solidity ^0.4.18;

import "./Administratable.sol";
import "../model/taskpool/TaskPool_Interface_admin.sol";

contract Distributable is Administratable, TaskPoolInterfaceAdmin {
    address public distributor_address;

    function Distributable(address _owner, address _admin) public Administratable(_owner, _admin) {}

    modifier distributor_only(){
        require(msg.sender == distributor_address || msg.sender == owner);
        _;
    }

    function set_distributor(address _distributor) admin_only external returns (bool){
        require(_distributor != address(0));
        distributor_address = _distributor;
        return controller_ready = true;
    }
}
