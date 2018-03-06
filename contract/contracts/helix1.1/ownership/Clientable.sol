pragma solidity ^0.4.18;

import "./Administratable.sol";
import "../model/account/Account_Interface_admin.sol";

contract Clientable is Administratable, AccountInterfaceAdmin {
    address public client_address;

    function Clientable(address _owner, address _admin) public Administratable(_owner, _admin) {}

    modifier client_only(){
        require(client_address == msg.sender || msg.sender == owner || msg.sender == admin_address);
        _;
    }

    function set_client(address _client) admin_only external returns (bool){
        require(_client != address(0));
        client_address = _client;
        return controller_ready = true;
    }
}
