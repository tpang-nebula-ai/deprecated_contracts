pragma solidity ^0.4.18;
import "./Ownable.sol";
import "../interface/queue/Queue_Interface_admin.sol";

contract Dispatchable is Ownable, QueueInterfaceAdmin {
    address public dispatcher_address;

    function Dispatchable(address _owner) Ownable(_owner) public {}

    modifier dispatcher_only(){
        require(dispatcher_address != address(0) && msg.sender == dispatcher_address);
        _;
    }

    function set_dispatcher(address _dispatcher) ownerOnly public returns (bool){
        require(_dispatcher != address(0));
        dispatcher_address = _dispatcher;
        return true;
    }
}
