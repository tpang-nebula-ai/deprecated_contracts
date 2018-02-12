pragma solidity ^0.4.18;

import "./Ownable.sol";

contract Administratable is Ownable {
    address public admin_address;
    bool public admin_loaded;
    bool public controller_ready;

    function Administratable(address _owner, address _admin) public Ownable(_owner) {
        if (_admin != address(0)) set_admin(_admin);
    }

    modifier Ready(){
        require(controller_ready);
        _;
    }

    modifier admin_only(){
        require(msg.sender == admin_address);
        _;
    }

    function set_admin(address _admin) ownerOnly public returns (bool){
        admin_address = _admin;
        admin_loaded = true;
    }
}
