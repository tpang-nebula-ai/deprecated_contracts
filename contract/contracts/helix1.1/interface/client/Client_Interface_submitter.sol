pragma solidity ^0.4.18;

interface ClientInterfaceSubmitter {
    function get_client_c() view external returns
    (
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level
    );

    function submissible(address _address, uint256 _app_id) view external returns (bool);
}
