pragma solidity ^0.4.18;

contract Ownable {
    address public owner;
    address public admin;

    function Ownable(address _owner_address) public {
        owner = _owner_address;
    }

    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }
    function set_admin(address _admin) public ownerOnly{
        admin = _admin;
    }

    function change_owner(address _owner) ownerOnly public {
        owner = _owner;
    }
}
