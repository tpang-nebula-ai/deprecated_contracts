pragma solidity ^0.4.18;

import "./Ownable.sol";

import "../interface/controller/Controller_Interface_admin.sol";

contract Controllable is Ownable, ControllerInterfaceAdmin
{
    bool public admin_loaded;
    bool public controller_ready;

    address public admin_address;
    address public dispatcher_address;
    address public distributor_address;
    address public client_address;


    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == admin_address);
        _;
    }
    modifier dispatcher_only(){
        require(dispatcher_address == msg.sender);
        _;
    }
    modifier distributor_only(){
        require(distributor_address == msg.sender);
        _;
    }
    modifier client_only(){
        require(client_address == msg.sender);
        _;
    }

    modifier Ready(){
        require(controller_ready);
        _;
    }

    function Controllable(address _owner, address _admin) public Ownable(_owner) {
        if (_admin != address(0)) set_admin(_admin);
    }

    function set_admin(address _admin) public ownerOnly returns (bool){
        admin_address = _admin;
        admin_loaded = true;
    }
    ///@dev Override this function with the corresponding class requirement
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model, address _task_queue) ownerOnly public returns (bool){
        require(admin_loaded);
        dispatcher_address = _dispatcher;
        distributor_address = _distributor;
        client_address = _client;
    }
}
