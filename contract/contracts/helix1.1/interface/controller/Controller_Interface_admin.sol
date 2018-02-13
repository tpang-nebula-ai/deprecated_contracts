pragma solidity ^0.4.18;

interface ControllerInterfaceAdmin {
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model, address _task_queue) public returns (bool);
}
