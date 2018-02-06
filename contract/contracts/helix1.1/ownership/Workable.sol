pragma solidity ^0.4.0;

import "./Dispatchable.sol";

contract Workable is Dispatchable {
    address public worker;

    function Workable(address _task_owner)
    Dispatchable(_task_owner)
    public {
        dispatcher = msg.sender;
    }
    modifier worker_only(){
        require(worker != address(0) && worker == msg.sender);
        _;
    }
    function change_worker(address _worker) dispatcher_only public {
        worker = _worker;
    }
}
