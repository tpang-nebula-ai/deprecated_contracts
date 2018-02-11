pragma solidity ^0.4.18;

interface DistributorInterfaceAdmin {
    function set_distributor(address _distributor) public returns (bool);
    function set_client(address _client) public returns (bool);
}
