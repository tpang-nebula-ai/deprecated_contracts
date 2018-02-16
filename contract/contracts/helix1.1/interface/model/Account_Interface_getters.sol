pragma solidity ^0.4.18;

interface AccountInterfaceGetters {
    function task_history() view public returns (address[]);

    function active_tasks() view public returns (address[]);

    function job_history() view public returns (address[]);

    function active_job() view public returns (address);

}
