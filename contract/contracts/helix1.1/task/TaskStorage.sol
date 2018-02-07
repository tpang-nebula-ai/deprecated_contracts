pragma solidity ^0.4.18;

import "../ownership/StorageManager.sol";

contract TaskStorage is StorageManager {
    struct Task {
        uint256 app_id;
        //uint256 public app_version;

        string task_name;
        string data_address;
        string script_address;
        string output_address;
        string parameters;

        uint create_time;
        uint dispatch_time;
        uint start_time;
        uint complete_time;

        bool started;
        bool completed;
        bool task_issue;
        bool cancelled;

        uint256 fee;
        uint256 completion_fee;
    }

    mapping(address => Task) pool;

    function TaskStorage() public StorageManager(msg.sender) {}
}