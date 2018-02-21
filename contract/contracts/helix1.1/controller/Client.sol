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
    using SafeMath for uint256;

    address account_address;
    AccountInterface account;

    DistributorInterfaceClient distributor;
    DispatcherInterfaceClient dispatcher;

    uint256 public penalty = 5 ether;
    uint256 penalty_to_client = penalty.div(10).mul(8);
    uint256 public minimal_credit = 15 ether;

    function Client(address _admin) public Controllable(msg.sender, _admin) {}

    function() {
        revert();
    }
    modifier valid_client(address _address){
        require(_address != address(0));
        _;
    }

    //Admin Interface
    function set_addresses(address _dispatcher, address _distributor, address _client, address _model, address _task_queue)
    admin_only public returns (bool){
        super.set_addresses(_dispatcher, _distributor, _client, _model, _task_queue);

        account_address = _model;
        account = AccountInterface(account_address);

        distributor = DistributorInterfaceClient(distributor_address);
        dispatcher = DispatcherInterfaceClient(dispatcher_address);

        controller_ready = true;
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
    function apply_eligibility() public Ready payable returns (bool){
        require(msg.value >= minimal_credit);
        bool _banned;
        bool _eligible;

        (_eligible, , , _banned,,,) = account.get_client(msg.sender);

        require(!_banned && !_eligible);
        assert(account.set_eligible(msg.sender, true, msg.value));
        //assert returned == true
        return true;
    }

    ///@dev intermediate
    function set_waiting(address _client, bool _waiting) controllers_only public returns (bool){
        return account.set_waiting(_client, _waiting);
    }
    ///@dev intermediate
    function add_job(address _client, bool _working, address _task) controllers_only public returns (bool){
        return account.add_job(_client, _working, _task);
    }
    ///@dev intermediate
    function set_banned(address _client, bool _banned) controllers_only public returns (bool){
        return account.set_banned(_client, _banned);
    }
    ///@dev intermediate
    //    function set_misconduct_counter(address _client, bool _increase, uint8 _amount) controllers_only public returns (uint8){
    //        return account.set_misconduct_counter(_client, _increase, _amount);
    //    }
    ///@dev intermediate
    function set_level(address _client, uint8 _level) controllers_only public returns (uint8){
        return account.set_level(_client, _level);
    }
    ///@dev intermediate
    function add_task(address _client, bool _new, address _task) controllers_only public returns (bool){
        return account.add_task(_client, _new, _task);
    }

    //@dev intermediate
    function set_working(address _worker, bool _working) controllers_only public returns (bool){
        return account.set_working(_worker, _working);
    }

    //@dev intermediate
    function pay_penalty(address _worker, address _client) controllers_only public returns (bool){
        uint256 _available_credits = account.get_credits(_worker);
        require(_available_credits > 0);
        uint256 _set_to;
        uint256 _to_client;
        if (_available_credits > penalty) {
            _set_to = _available_credits.sub(penalty);
            _to_client = penalty_to_client;
        } else {
            _set_to = 0;
            _to_client = _available_credits.mul(8).div(10);
        }
        assert((_available_credits = _set_to) == account.set_credits(_worker, _set_to));

        if (_available_credits < penalty) assert(account.set_banned(_worker, true));

        _client.transfer(penalty_to_client);
        return true;
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
    function get_client_m() view public returns (
        bool _eligible,
        bool _waiting,
        bool _working,
        bool _banned,
        uint8 _misconduct_counter){
        (_eligible, _waiting, _working, _banned, _misconduct_counter, , ) = account.get_client(msg.sender);
    }

    function get_credits() external view returns (uint256){
        return account.get_credits(msg.sender);
    }

    function withdrawal(uint256 _amount) external returns (uint256){
        uint256 _balance = account.get_credits(msg.sender);
        _balance = _balance.sub(_amount);
        //safemath throws if _amount > _balance
        assert(account.set_credits(msg.sender, _balance) == _balance);
        msg.sender.transfer(_amount);
        return _balance;
    }
}
