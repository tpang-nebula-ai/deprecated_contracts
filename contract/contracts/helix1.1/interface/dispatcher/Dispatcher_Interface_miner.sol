pragma solidity ^0.4.18;

interface DispatcherInterfaceMiner {

    function join_ai_queue() external returns (bool);

    function leave_ai_queue() external returns (bool);

    function ai_queue_length() view external returns (uint256);

    function ai_position(address _worker) view external returns (uint256);
}
