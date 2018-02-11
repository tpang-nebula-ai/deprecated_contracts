pragma solidity ^0.4.18;

interface Client_Interface_admin {
    function set_distributor(address _distributor) ownerOnly public returns (bool);
    function set_dispatcher(address _dispatcher)
}
