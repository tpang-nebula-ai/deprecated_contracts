pragma solidity ^0.4.18;

import "../misc/SafeMath.sol";
import "../ownership/Dispatchable.sol";
import "../interface/Dispatcher_Interface_distributor.sol";
import "../interface/TaskPool_Interface.sol";
import "../interface/Distributor_Interface_client.sol";
import "../interface/Distributor_Interface_miner.sol";
import "../interface/Distributor_Interface_dispatcher.sol";

//TODO add safeMath
//This layer is necessary for security and control reason
//Otherwise no way to control what are send to task queue while able to keep Task modular
contract Distributor is Dispatchable, DistributorInterfaceClient, DistributorInterfaceMiner, DistributorInterfaceNebula {
    using SafeMath for uint256;
    DispatcherInterfaceDistributor dispatcher_at;

    address public pool_address;
    TaskPoolInterface pool;
    bool public pool_ready;
    uint public mininal_fee;


    ///@dev used to store ALL submitted task
    function Distributor(uint256 _minimal_fee) public Dispatchable(msg.sender) {
        mininal_fee = _minimal_fee == 0 ? 5 ether : _minimal_fee;
    }

    modifier contract_ready(){
        require(pool_ready);
        _;
    }
    //@dev override
    function setDispatcher(address _dispatcher) ownerOnly public {
        super.setDispatcher(_dispatcher);
        dispatcher_at = DispatcherInterfaceDistributor(dispatcher);
    }

    function set_taskpool_contract(address _pool_address) ownerOnly public {
        require(_pool_address != 0);
        pool_address = _pool_address;
        pool = TaskPoolInterface(pool_address);
        pool_ready = true;
    }


    //------------------------------------------------------------------------------------------------------------------
    //Client
    function create_task(uint256 _app_id, string _name, string _data, string _script, string _output, string _params)
    contract_ready public payable returns (address _task){
        //        require(app.valid_id(_app_id)) app_id needs to be valid , TODO a contract that keep tracks of the app id
        require(msg.value >= mininal_fee && _app_id != 0);
        _task = pool.create(_app_id, _name, _data, _script, _output, _params, msg.value);
    }

    function cancel_task(address _task) contract_ready public returns (bool){

    }

    function reassignable(address _task) view public returns (bool){

    }

    function reassign_task_request(address _task) public {

    }
    //------------------------------------------------------------------------------------------------------------------
    //Miner
    function report_start(address _task) public returns (bool){

    }

    function report_finish(address _task, uint256 _complete_fee) public {

    }

    function report_error(address _task, string _error_msg) public {

    }

    function forfeit(address _task) public {

    }

    //------------------------------------------------------------------------------------------------------------------
    //Dispatcher
    function dispatch_task(address _task, address _worker) public {

    }

    //------------------------------------------------------------------------------------------------------------------
    //getters
    function get_task(address _task)
    view public returns (uint256 _app_id, string _name, string _data, string _script, string _output, string _params){

    }

    function get_status(address _task)
    view public returns (uint _create_time, uint dispatch_time, uint start_time, uint complete_time, uint _cancel_time, uint _error_time){

    }

    function get_worker(address _task) view public returns (address){

    }

    function get_error_msg(address _task) view public returns (string){

    }

    function get_fees(address _task) view public returns (uint256 _fee, uint256 _completion_fee){

    }
}