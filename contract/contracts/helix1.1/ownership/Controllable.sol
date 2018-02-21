pragma solidity ^0.4.18;

import "./Administratable.sol";

import "../interface/controller/Controller_Interface_admin.sol";

contract Controllable is Administratable, ControllerInterfaceAdmin
{
    address public dispatcher_address;
    address public distributor_address;
    address public client_address;

    //@dev  == owner will be removed , testing purpose only
    modifier dispatcher_only(){
        require(dispatcher_address == msg.sender || msg.sender == admin_address || msg.sender == owner);
        _;
    }
    //@dev  == owner will be removed , testing purpose only
    modifier distributor_only(){
        require(distributor_address == msg.sender || msg.sender == admin_address || msg.sender == owner);
        _;
    }
    //@dev  == owner will be removed , testing purpose only
    modifier client_only(){
        require(client_address == msg.sender || msg.sender == admin_address || msg.sender == owner);
        _;
    }
    //@dev  == owner will be removed , testing purpose only
    modifier controllers_only(){
        require(dispatcher_address == msg.sender || distributor_address == msg.sender || client_address == msg.sender
        || msg.sender == admin_address || msg.sender == owner);
        _;
    }

    function Controllable(address _owner, address _admin) public Administratable(_owner, _admin) {
    }

    ///@dev Override this function with the corresponding class requirement
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model, address _task_queue) admin_only public returns (bool){
        require(admin_loaded);
        dispatcher_address = _dispatcher;
        distributor_address = _distributor;
        client_address = _client;
    }
}
