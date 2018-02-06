pragma solidity ^0.4.18;

interface ClientInterfaceClient {
    function get_client_c() view public returns
    (
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level,
        bool _submissible
    );

    function task_history() view public returns (address[]);

    function active_tasks() view public returns (address[]);
}
