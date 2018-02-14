pragma solidity ^0.4.18;

interface ClientInterfaceDistributor {
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

    function add_job(address _client, bool _working, address _task) public returns (bool);

    function add_task(address _client, bool _new, address _task) public returns (bool);
}