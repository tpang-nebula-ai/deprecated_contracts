pragma solidity ^0.4.0;

interface ClientInterfaceAdmin {
    function set_banned(address _client, bool _banned) external returns (bool);

    function set_level(address _client, uint8 _level) external returns (uint8);
    //function set_waiting(address _client, bool _waiting) external returns(bool);//should not simply change the waiting status
    //function add_job(address _client, bool _working, address _task) external returns(bool)//should not simply change the job
    //function add_task(address _client, bool _new, address _task, uint256 _app_id)external returns(bool)//should not simply change the task
    function get_client(address _address) external view returns (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level);

    function get_minimal_credit() external view returns (uint256);


}
