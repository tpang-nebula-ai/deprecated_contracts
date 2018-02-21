pragma solidity ^0.4.18;

interface ClientInterfaceDispatcher {
    function get_client(address _address) view external returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level
    );

    function set_waiting(address _client, bool _waiting) external returns (bool);

    function add_job(address _client, bool _working, address _task) external returns (bool);

    // function set_banned(address _client, bool _banned) external returns (bool);

    // function set_level(address _client, uint8 _level) external returns (uint8);

    // function add_task(address _client, bool _new, address _task) external returns (bool);
}
