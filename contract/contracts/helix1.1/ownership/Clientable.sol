pragma solidity ^0.4.18;

import "./Administratable.sol";
import "../model/account/Account_Interface_admin.sol";

contract Clientable is Administratable, AccountInterfaceAdmin {
    address public client_address;

    function Clientable(address _owner, address _admin) public Administratable(_owner, _admin) {}

    modifier client_only(){
        require(client_address == msg.sender || msg.sender == owner);
        _;
    }

    function set_client(address _client) admin_only public returns (bool){
        require(_client != address(0));
        client_address = _client;
        controller_ready = true;
        return true;
    }
}
