pragma solidity ^0.4.18;

interface AccountInterface {
    //dispatcher
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

    function set_banned(address _client, bool _banned) external returns (bool);

    //    function set_misconduct_counter(address _client, bool _increase, uint8 _amount) external returns (uint8);

    function set_level(address _client, uint8 _level) external returns (uint8);

    function add_task(address _client, bool _new, address _task, uint256 _app_id) external returns (bool);

    function submissible(address _address, uint256 _app_id) view external returns (bool);//submitter and dispatcher

    function set_eligible(address _worker, bool _eligible, uint256 _credit) external returns (bool);

    function set_credits(address _worker, uint256 _credit) external returns (uint256);

    function get_credits(address _client) external view returns (uint256);

    //miner
    function active_job() view external returns (address);

    //distributor
    //    function set_working(address _worker, bool _working) external returns (bool);
}
