pragma solidity ^0.4.18;

interface ClientInterfaceDistributor {
    function get_client(address _address) view external returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level
    );

    function submissible(address _client, uint256 _app_id) view external returns (bool);

    function add_job(address _client, bool _working, address _task) external returns (bool);

    function add_task(address _client, bool _new, address _task, uint256 _app_id) external returns (bool);

    //    function set_misconduct_counter(address _client, bool _increase, uint8 _amount) public returns (uint8);

    function pay_penalty(address _worker, address _owner) external returns (bool);
}
