pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";
import "./Nebula_Interface.sol";
import "../task/Task.sol";

contract Nebula is Nebula_Interface, Onwable {
    function Nebula()
    public
    Ownable(msg.sender)
    {

    }

    function join(address _address) public payable returns (bool) {
        Task task = Task(_address);


    }

    function leave() public returns (bool){

    }

    function rejoin() public returns (bool){

    }


}
