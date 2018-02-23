pragma solidity ^0.4.18;

interface ClientInterfaceMiner {
    function get_client_m() view external returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter
    );

    function get_minimal_credit() external view returns (uint256);

    function apply_eligibility() external payable returns (bool);

    function withdrawal(uint256 _amount) external returns (uint256);
}
