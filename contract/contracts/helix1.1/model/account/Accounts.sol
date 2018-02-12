pragma solidity ^0.4.18;

import "../../misc/SafeMath.sol";
import "../../ownership/Clientable.sol";
import "../../interface/model/Account_Interface.sol";

contract Accounts is Clientable, AccountInterface {
    using SafeMath for uint8;
    struct Account {
        //both
        bool banned;
        uint8 misconduct_counter;
        //client
        uint8 level;
        address[] task_history;
        address[] active_tasks;
        //worker
        bool eligible;
        bool waiting;
        bool working;
        address[] job_history;
        address active_job;
    }

    mapping(address => Account) accounts;

    function Accounts(address _admin) public Clientable(msg.sender, _admin) {
    }
}
