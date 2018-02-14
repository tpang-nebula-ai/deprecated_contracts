pragma solidity ^0.4.18;

import "./Queue.sol";

contract Queue_Ai is Queue {
    function Queue_Ai(address _admin) public Queue(_admin) {
    }
}

contract Queue_Task is Queue {
    function Queue_Task(address _admin) public Queue(_admin) {
    }
}
