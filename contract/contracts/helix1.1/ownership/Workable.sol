pragma solidity ^0.4.0;

import "./Dispatchable.sol";

contract Workable is Dispatchable {
    address public worker;
    address public task_pool_address;

    function Workable(address _owner, address _dispatcher)
    Dispatchable(_owner)
    public {
        dispatcher = _dispatcher;
        task_pool_address = msg.sender;
    }
    modifier worker_only(){
        require(worker != address(0) && worker == msg.sender);
        _;
    }
    function change_worker(address _worker) dispatcher_only public {
        worker = _worker;
    }
}
