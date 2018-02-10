pragma solidity ^0.4.18;
import "../ownership/Dispatchable.sol";
import "../misc/SafeMath.sol";
import "../interface/Client_Interface_dispatcher.sol";
import "../interface/Client_Interface_client.sol";
import "../interface/Client_Interface_miner.sol";
import "../interface/Client_Interface_dispatcher.sol";

///@dev logic should be added
contract Client is Dispatchable, ClientInterfaceClient, ClientInterfaceMiner, ClientInterfaceDispatcher {
    using SafeMath for uint256;
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

    modifier contract_ready(){
        //require();
        _;
    }
    
    modifier valid_client(address _address){
        require(_address != address(0));
        _;
    }
    
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
        require(_address != address(0));
        return (accounts[_address].eligible, accounts[_address].waiting, accounts[_address].working,
        accounts[_address].banned, accounts[_address].misconduct_counter, accounts[_address].level, submissible(_address));
    }

    function submissible(address _address) view public returns (bool){
        return accounts[_address].active_tasks.length < accounts[_address].level + 1;
    }

    function set_eligible(address _client, bool _eligible) valid_client(_client) dispatcher_only public returns (bool){
        accounts[_client].eligible = _eligible;
        return true;
    }

    function set_waiting(address _client, bool _waiting) valid_client(_client) dispatcher_only public returns (bool){
        accounts[_client].waiting = _waiting;
        return true;
    }

    function add_job(address _client, bool _working, address _task) valid_client(_client) dispatcher_only public returns (bool){
        if (_working) {
            require(accounts[_client].waiting && _task != address(0));
            accounts[_client].waiting = false;
            accounts[_client].job_history.push(_task);
            accounts[_client].active_job = _task;
        } else {
            accounts[_client].active_job = 0;   
        }
        accounts[_client].working = _working;
        return true;
    }

    function set_banned(address _client, bool _banned) valid_client(_client) dispatcher_only public returns (bool){
        accounts[_client].banned = _banned;
        if (_banned) {
            accounts[_client].eligible = false;
            accounts[_client].waiting = false;
            accounts[_client].working = false;
        }
        return true;
    }

    function set_misconduct_counter(address _client, bool _increase, uint256 _amount) valid_client(_client) dispatcher_only public returns (bool){
        if (_increase) {
            accounts[_client].misconduct_counter.add(_amount);
            if (accounts[_client].misconduct_counter == 3) set_banned(_client, true);
        } else {
            require(accounts[_client].misconduct_counter > 0);
            accounts[_client].misconduct_counter.sub(_amount);
            if (accounts[_client].misconduct_counter < 3) set_banned(_client, false);
        }
        return true;
    }

    function set_level(address _client, uint8 _level) valid_client(_client) dispatcher_only public returns (bool){
        require(_level >= 0 && _level <= 10);
        accounts[_client].level = _level;
        return true;
    }

    function add_task(address _client, bool _new, address _task) valid_client(_client) dispatcher_only public returns (bool){
        require(_task != address(0));
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
        var list = accounts[_client].active_tasks;
        for (uint index = 0; index < list.length; index++) {
            if (list[index] == _task) {
                for (uint i = index; i < list.length - 1; i++) list[i] = list[i + 1];
                delete list[list.length - 1];
                list.length--;
                return true;
            }
        }
        return false;
    }
    //Client
    function get_client_c() view public returns (
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level,
        bool _submissible
    ){
        return (accounts[msg.sender].banned, accounts[msg.sender].misconduct_counter, accounts[msg.sender].level, submissible(msg.sender));
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
