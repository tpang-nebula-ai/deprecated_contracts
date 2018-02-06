pragma solidity ^0.4.18;

import "../ownership/Dispatchable.sol";
import "../interface/Client_Interface_nebula.sol";
import "../interface/Client_Interface_client.sol";
import "../interface/Client_Interface_miner.sol";

contract Client is Dispatchable, ClientInterfaceNebula, ClientInterfaceClient, ClientInterfaceMiner {

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

    function Client() public Dispatchable(msg.sender) {}

    //Nebula Main Contract Interface
    function get_client(address _address) view public returns (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level,
        bool _submissible)
    {
        bool submissible = accounts[_address].active_tasks.length < accounts[_address].level - 1;
        return (accounts[_address].eligible, accounts[_address].waiting, accounts[_address].working,
        accounts[_address].banned, accounts[_address].misconduct_counter, accounts[_address].level, submissible);
    }

    function set_eligible(address _client, bool _eligible) public returns (bool){

    }

    function set_waiting(address _client, bool _waiting) public returns (bool){

    }

    function add_job(address _client, bool _working, address _task) public returns (bool){

    }

    function set_banned(address _client, bool _banned) public returns (bool){

    }

    function set_misconduct_counter(address _client, bool _increase) public returns (bool){

    }

    function set_level(address _client, uint _level) public returns (bool){

    }

    function add_task(address _client, bool _new, address _task) public returns (bool){

    }
    //Client
    function get_client_c() view public returns (
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level,
        bool _submissible
    ){
        bool submissible = accounts[msg.sender].active_tasks.length < accounts[msg.sender].level - 1;
        return (
        accounts[msg.sender].banned, accounts[msg.sender].misconduct_counter,
        accounts[msg.sender].level, submissible
        );
    }

    function task_history() view public returns (address[]){
        return accounts[msg.sender].task_history;
    }

    function active_tasks() view public returns (address[]){
        return accounts[msg.sender].active_tasks;
    }


    //Miner Interface
    function get_client_m() view public returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter
    ){
        return (
        accounts[msg.sender].eligible, accounts[msg.sender].waiting, accounts[msg.sender].working,
        accounts[msg.sender].banned, accounts[msg.sender].misconduct_counter
        );
    }

    function job_history() view public returns (address[]){
        return accounts[msg.sender].job_history;
    }

    function active_job() view public returns (address){
        return accounts[msg.sender].active_job;
    }
}
