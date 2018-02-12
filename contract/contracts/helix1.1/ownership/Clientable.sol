pragma solidity ^0.4.18;

import "./Ownable.sol";
import "../interface/account/Account_Interface_admin.sol";

contract Clientable is Ownable, AccountInterfaceAdmin {
    address public client_address;

    function Clientable(address _owner) public Ownable(_owner) {}

    modifier client_only(){
        require(client_address != address(0) && client_address == msg.sender);
        _;
    }
    function set_client(address _client) ownerOnly public returns (bool){
        require(_client != address(0));
        client_address = _client;
        return true;
    }
}
