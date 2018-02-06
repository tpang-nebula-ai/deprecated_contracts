pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";
import "../interface/Client_Interface.sol";

contract Client is Ownable, ClientInterface {

    struct Account {
        bool eligible;
        bool waiting;
        bool working;
        bool banned;
        uint8 misconduct_counter;
        uint8 level;
        address[] task_history;
        address[] active_tasks;

        address[] job_history;
        address active_job;
    }

    address public dispatcher_address;

    mapping(address => Account) accounts;

    modifier dispatcher_only(){
        require(msg.sender == dispatcher_address);
        _;
    }

    function Client(address _dispatcher_address)
    public
    Ownable(msg.sender)
    {}

    function set_dispatcher(address _dispatcher_address) ownerOnly public {
        require(_dispatcher_address != address(0));
        dispatcher_address = _dispatcher_address;
    }

    //getters
    function get_client(address _client_address) view public returns (
        bool eligible,
        bool waiting,
        bool working,
        bool banned,
        uint8 misconduct_counter,
        uint8 level) {
        return (
        accounts[_client_address].eligible,
        accounts[_client_address].waiting,
        accounts[_client_address].working,
        accounts[_client_address].banned,
        accounts[_client_address].misconduct_counter,
        accounts[_client_address].level
        );
    }

    function can_submit_new_task(address _client_address) view public returns (bool){
        return accounts[_client_address].active_tasks.length < accounts[_client_address].level - 1;
    }

    //complete from 0
    function get_complete_task_history(address _client_address) view public returns (address[]){
        return accounts[_client_address].task_history;
    }

    function get_active_tasks(address _client_address) view public returns (address[]){
        return accounts[_client_address].active_tasks;
    }

    function get_job_list(address _client_address) view public returns (address[]){
        return accounts[_client_address].job_history;
    }

    function get_active_job(address _client_address) view public returns (address){
        return accounts[_client_address].active_job;
    }

    //setters
    //Need to meet some requirement
    function apply_for_mining() public returns (bool){
        require(accounts[msg.sender].eligible == false && accounts[msg.sender].banned == false);
        accounts[msg.sender].eligible = true;
        return true;
    }

    //start waiting, not working
    function join_queue() dispatcher_only public returns (bool){

    }

    function leave_queue() dispatcher_only public returns (bool){

    }

    function assign_task() dispatcher_only public returns (bool){

    }

    function reassign_task() dispatcher_only public returns (bool){

    }

    function ban_client(address _client_address) internal returns (bool){
        require(accounts[_client_address].misconduct_counter == 3);
        accounts[_client_address].banned = true;
    }

    function unban_client(address _client_address) ownerOnly public returns (bool){
        require(accounts[_client_address].banned);
        accounts[_client_address].banned = false;
    }
    
}
