pragma solidity ^0.4.18;

interface AccountInterfaceGetters {
    function task_history(uint256 _app_id) view external returns (address[]);

    function active_tasks(uint256 _app_id) view external returns (address[]);

    function job_history() view external returns (address[]);

    function active_job() view external returns (address);

    function get_credits() external view returns (uint256);
}
