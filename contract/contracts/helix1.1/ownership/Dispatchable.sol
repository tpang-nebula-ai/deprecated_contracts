pragma solidity ^0.4.18;

import "./Administratable.sol";
import "../model/queue/Queue_Interface_admin.sol";

contract Dispatchable is Administratable, QueueInterfaceAdmin {
    address public dispatcher_address;

    function Dispatchable(address _owner, address _admin) Administratable(_owner, _admin) public {}

    modifier dispatcher_only(){
        require(msg.sender == dispatcher_address || msg.sender == owner);
        _;
    }

    function set_dispatcher(address _dispatcher) admin_only external returns (bool){
        require(_dispatcher != address(0));
        dispatcher_address = _dispatcher;
        controller_ready = true;
        return true;
    }
}
