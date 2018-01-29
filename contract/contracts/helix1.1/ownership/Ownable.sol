pragma solidity ^0.4.18;

contract Ownable {
    address public owner;

    function Ownable(address _owner_address){
        owner = _owner_address;
    }

    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }
}
