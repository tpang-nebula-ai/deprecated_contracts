pragma solidity ^0.4.18;

interface ClientInterface {
    function get_client(address _client_address) view public returns
    (
        bool eligible,
        bool waiting,
        bool working,
        bool banned,
        uint8 misconduct_counter,
        uint8 level
    );
}
