pragma solidity ^0.4.18;


contract Nebula_Queue is Nebula_Interface {
    function Nebula_Queue(){

    }

    function join(Task_Template _address) public returns (bool){
        Task_Template template = Task_Template(_address);
        //how do i know this is a valid task contract

    }

    function leave() public returns (bool){

    }

    function rejoin() public returns (bool){

    }


}
