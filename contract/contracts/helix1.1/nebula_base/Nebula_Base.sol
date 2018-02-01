pragma solidity ^0.4.18;

import "../task/Task_Template.sol";
import "./Nebula_Interface.sol";


contract Nebula_Base is Nebula_Interface {
    function Nebula_Base(){

    }

    function join(address _address) public payable returns (bool) {
        Task_Template template = Task_Template(_address);
        //how do i know this is a valid task contract

    }

    function leave() public returns (bool){

    }

    function rejoin() public returns (bool){

    }


}
