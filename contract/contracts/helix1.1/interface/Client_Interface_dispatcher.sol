pragma solidity ^0.4.18;

interface ClientInterfaceNebula {
    function get_client(address _address) view public returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level,
        bool _submissible
    );

    function submissible(address _address) view public returns (bool);

    function set_eligible(address _client, bool _eligible) public returns (bool);

    function set_waiting(address _client, bool _waiting) public returns (bool);

    function add_job(address _client, bool _working, address _task) public returns (bool);

    function set_banned(address _client, bool _banned) public returns (bool);

    function set_misconduct_counter(address _client, bool _increase) public returns (bool);

    function set_level(address _client, uint8 _level) public returns (bool);

    function add_task(address _client, bool _new, address _task) public returns (bool);
}
