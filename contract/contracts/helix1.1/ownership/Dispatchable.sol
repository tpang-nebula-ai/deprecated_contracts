pragma solidity ^0.4.18;

import "./Ownable.sol";

contract Dispatchable is Ownable {
    address public dispatcher;


    function Dispatchable(address _owner)
    Ownable(_owner)
    public {
    }
    modifier dispatcher_only(){
        require(dispatcher != address(0) && msg.sender == dispatcher);
        _;
    }
    function set_dispatcher(address _dispatcher) ownerOnly public {
        dispatcher = _dispatcher;
    }
}
