pragma solidity ^0.4.18;

interface NebulaInterfaceMiner {
    function apply_eligibility() public returns(bool);

    function join_ai_queue() public returns(bool);

    function leave_ai_queue() public returns(bool);
}
