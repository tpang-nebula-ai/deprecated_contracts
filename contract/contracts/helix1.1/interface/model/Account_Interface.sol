pragma solidity ^0.4.18;

interface AccountInterface {
    //dispatcher
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

    function set_waiting(address _client, bool _waiting) public returns (bool);

    function add_job(address _client, bool _working, address _task) public returns (bool);

    function set_banned(address _client, bool _banned) public returns (bool);

    function set_misconduct_counter(address _client, bool _increase, uint8 _amount) public returns (uint8);

    function set_level(address _client, uint8 _level) public returns (uint8);

    function add_task(address _client, bool _new, address _task) public returns (bool);

    function submissible(address _address) view public returns (bool);//submitter and dispatcher

    function set_eligible(address _worker, bool _eligible, uint256 _credit) public returns (bool);

    function set_credits(address _worker, bool _increase, uint256 _credit) public returns (uint256);

    //miner
    function active_job() view public returns (address);

    //distributor
    function set_working(address _worker, bool _working) public returns (bool);
}
