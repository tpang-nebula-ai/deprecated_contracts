pragma solidity ^0.4.18;

contract Client {

    struct Account {
        bool eligible;
        bool waiting;
        bool working;
        bool banned;
        uint8 misconduct_counter;
        uint8 level;
        address[] submitted_task_history;
        address[] submitted_task_active;
        address[] assigned_task_list;
        address current_assigned_task;

    }

    address public creator_address;

    address public dispatcher_address;

    mapping(address => Account) accounts;

    modifier creator_only(){
        require(msg.sender == creator_address);
        _;
    }
    modifier dispatcher_only(){
        require(msg.sender == dispatcher_address);
        _;
    }

    function Client(address _dispatcher_address) public {
        require();
        dispatcher_address = _dispatcher_address;
    }

    function change_dispatcher(address _new_dispatcher_address) dispatcher_only public {
        require(_new_dispatcher_address != address(0));
        dispatcher_address = _new_dispatcher_address;
    }
}
