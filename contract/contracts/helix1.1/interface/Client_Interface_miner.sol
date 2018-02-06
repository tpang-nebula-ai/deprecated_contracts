pragma solidity ^0.4.18;

interface ClientInterfaceMiner {
    function get_client_m() view public returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter
    );

    function job_history() view public returns (address[]);

    function active_job() view public returns (address);
}
