pragma solidity ^0.4.18;

contract Ownable {
    address public owner;

    function Ownable(address _owner_address) public {
        owner = _owner_address;
    }

    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }

    function change_owner(address _owner) ownerOnly external {
        owner = _owner;
    }
}
