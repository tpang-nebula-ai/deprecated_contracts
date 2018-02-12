pragma solidity ^0.4.18;

import "../misc/SafeMath.sol";
import "../ownership/Controllable.sol";

import "../interface/model/Account_Interface.sol";

import "../interface/client/Client_Interface_dispatcher.sol";
import "../interface/client/Client_Interface_distributor.sol";
import "../interface/client/Client_Interface_submitter.sol";
import "../interface/client/Client_Interface_miner.sol";

import "../interface/distributor/Distributor_Interface_client.sol";
import "../interface/dispatcher/Dispatcher_Interface_client.sol";

///@dev logic should be added
contract Client is Controllable,
ClientInterfaceSubmitter, ClientInterfaceMiner, ClientInterfaceDispatcher, ClientInterfaceDistributor
{
    address public account_address;
    AccountInterface account;

    DistributorInterfaceClient distributor;
    DispatcherInterfaceClient dispatcher;

    function Client(address _admin) public Controllable(msg.sender, _admin) {}

    modifier valid_client(address _address){
        require(_address != address(0));
        _;
    }

    //Admin Interface
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model, address _task_queue) admin_only public returns (bool){
        super.set_addresses(_dispatcher, _distributor, _client, _model, _task_queue);

        account_address = _model;
        account = AccountInterface(account_address);

        distributor = DistributorInterfaceClient(distributor_address);
        dispatcher = DispatcherInterfaceClient(dispatcher_address);

        controller_ready = true;
        //todo add a checker function
        return true;
    }

    //dispatcher Interface
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
        (_eligible, _waiting, _working, _banned, _misconduct_counter, _level, _submissible) = account.get_client(_address);
    }
    ///@dev getter
    function submissible(address _address) view public returns (bool){
        return account.submissible(_address);
    }

    ///@dev entry point
    function apply_eligibility() Ready public returns (bool){
        bool _banned;
        bool _eligible;
        bool _waiting;
        bool _working;
        (_eligible, _waiting, _working, _banned, , ,) = account.get_client(msg.sender);
        require(!_banned && !_eligible && !_waiting && !_working);
        assert(account.set_eligible(msg.sender, true) == true);
        return true;
    }

    ///@dev intermediate
    function set_waiting(address _client, bool _waiting) valid_client(_client) dispatcher_only public returns (bool){
        return account.set_waiting(_client, _waiting);
    }
    ///@dev intermediate
    function add_job(address _client, bool _working, address _task) valid_client(_client) public returns (bool){
        require(msg.sender == dispatcher_address || msg.sender == distributor_address);
        return account.add_job(_client, _working, _task);
    }
    ///@dev intermediate
    function set_banned(address _client, bool _banned) valid_client(_client) dispatcher_only public returns (bool){
        return account.set_banned(_client, _banned);
    }
    ///@dev intermediate
    function set_misconduct_counter(address _client, bool _increase, uint8 _amount) valid_client(_client) dispatcher_only public returns (uint8){
        return account.set_misconduct_counter(_client, _increase, _amount);
    }
    ///@dev intermediate
    function set_level(address _client, uint8 _level) valid_client(_client) dispatcher_only public returns (uint8){
        return account.set_level(_client, _level);
    }
    ///@dev intermediate
    function add_task(address _client, bool _new, address _task) valid_client(_client) public returns (bool){
        require(msg.sender == dispatcher_address || msg.sender == distributor_address);
        return account.add_task(_client, _new, _task);
    }

    //Distributor
    function set_working(address _worker, bool _working) distributor_only public returns (bool){
        account.set_working(_worker, _working);
        return;
    }

    //submitter Interface
    ///@dev getter
    function get_client_c() view public returns (
        bool _banned,
        uint8 _misconduct_counter,
        uint8 _level,
        bool _submissible
    ){
        (, , , _banned, _misconduct_counter, _level, _submissible) = account.get_client(msg.sender);
    }

    //Miner Interface
    ///@dev getter
    function get_client_m() view public returns
    (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter
    ){
        (_eligible, _waiting, _working, _banned, _misconduct_counter, , ) = account.get_client(msg.sender);
    }
    ///@dev getter
    function active_job() view public returns (address){
        return account.active_job();
    }
}
