pragma solidity ^0.4.18;

import "../../misc/SafeMath.sol";
import "../../ownership/Clientable.sol";
import "../../interface/model/Account_Interface.sol";
import "../../interface/model/Account_Interface_getters.sol";

contract Accounts is Clientable, AccountInterface, AccountInterfaceGetters {
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

    //Dispatcher interface
    function get_client(address _address) view public returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level,
        bool _submissible
    ){
        return (accounts[_address].eligible, accounts[_address].waiting, accounts[_address].working,
        accounts[_address].banned, accounts[_address].misconduct_counter, accounts[_address].level, submissible(_address));
    }

    function submissible(address _address) view public returns (bool){
        return accounts[_address].active_tasks.length < accounts[_address].level + 1;
    }

    function set_eligible(address _client, bool _eligible) client_only public returns (bool){
        return accounts[_client].eligible = _eligible;
    }

    function set_waiting(address _client, bool _waiting) client_only public returns (bool){
        return accounts[_client].waiting = _waiting;
    }

    function add_job(address _client, bool _working, address _task) client_only public returns (bool){
        if (_working) {
            require(accounts[_client].waiting && _task != address(0));
            accounts[_client].waiting = false;
            accounts[_client].job_history.push(_task);
            accounts[_client].active_job = _task;
        } else {
            accounts[_client].active_job = 0;
        }
        return accounts[_client].working = _working;
    }

    function set_banned(address _client, bool _banned) client_only public returns (bool){
        if (_banned) {
            accounts[_client].eligible = false;
            accounts[_client].waiting = false;
            accounts[_client].working = false;
        }
        return accounts[_client].banned = _banned;
    }

    function set_misconduct_counter(address _client, bool _increase, uint8 _amount) client_only public returns (uint8){
        if (_increase) {
            accounts[_client].misconduct_counter.add(_amount);
            if (accounts[_client].misconduct_counter == 3) set_banned(_client, true);
        } else {
            require(accounts[_client].misconduct_counter > 0);
            accounts[_client].misconduct_counter.sub(_amount);
            if (accounts[_client].misconduct_counter < 3) set_banned(_client, false);
        }
        return accounts[_client].misconduct_counter;
    }

    function set_level(address _client, uint8 _level) client_only public returns (uint8){
        return accounts[_client].level = _level;
    }

    function add_task(address _client, bool _new, address _task) client_only public returns (bool){
        if (_new) {
            require(submissible(_client));
            accounts[_client].task_history.push(_task);
            accounts[_client].active_tasks.push(_task);
            return true;
        } else {
            return removeFromActiveList(_client, _task);
        }
    }

    function removeFromActiveList(address _client, address _task) internal returns (bool){
        address[] memory list = accounts[_client].active_tasks;
        for (uint index = 0; index < list.length; index++) {
            if (list[index] == _task) {
                for (uint i = index; i < list.length - 1; i++) list[i] = list[i + 1];
                delete accounts[_client].active_tasks[list.length - 1];
                accounts[_client].active_tasks.length--;
                return true;
            }
        }
        return false;
    }

    //miner
    function job_history() view public returns (address[]){
        return accounts[msg.sender].job_history;
    }

    function active_job() view public returns (address){
        return accounts[msg.sender].active_job;
    }

    //submitter
    function task_history() view public returns (address[]){
        return accounts[msg.sender].task_history;
    }

    function active_tasks() view public returns (address[]){
        return accounts[msg.sender].active_tasks;
    }

    //distributor
    function set_working(address _worker, bool _working) client_only public returns (bool){
        return accounts[_worker].working = _working;
    }
}
