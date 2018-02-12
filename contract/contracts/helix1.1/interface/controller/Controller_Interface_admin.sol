pragma solidity ^0.4.18;

interface ControllerInterfaceAdmin {
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model1, address _model2) public returns (bool);
}
