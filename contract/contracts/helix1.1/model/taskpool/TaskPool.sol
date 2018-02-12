pragma solidity ^0.4.18;

import "../../ownership/Distributable.sol";
import "../../interface/model/TaskPool_Interface.sol";

contract TaskPool is Distributable, TaskPoolInterface {

    struct Task {
        uint256 app_id;
        string task_name;
        string data_address;
        string script_address;
        string output_address;
        string parameters;
        uint256 fee;
        uint256 completion_fee;
        address owner;
        address worker;
        uint create_time;
        uint dispatch_time;
        uint start_time;
        uint complete_time;
        uint cancel_time;
        uint error_time;
        string error_message;
    }

    uint160 public nonce;
    mapping(address => Task) pool;

    function TaskPool(address _admin, uint160 _nonce) public Distributable(msg.sender, _admin) {nonce = _nonce;}

    //------------------------------------------------------------------------------------------------------------------
    //Getters
    function get_task(address _task)
    view public returns (uint256 _app_id, string _name, string _data, string _script, string _output, string _params)
    {
        return (
        pool[_task].app_id,
        pool[_task].task_name,
        pool[_task].data_address,
        pool[_task].script_address,
        pool[_task].output_address,
        pool[_task].parameters
        );
    }

    function get_status(address _task)
    view public returns (uint _create_time, uint _dispatch_time, uint _start_time, uint _complete_time, uint _cancel_time, uint _error_time)
    {
        return (
        pool[_task].create_time,
        pool[_task].dispatch_time,
        pool[_task].start_time,
        pool[_task].complete_time,
        pool[_task].cancel_time,
        pool[_task].error_time
        );
    }

    function get_worker(address _task) view public returns (address){
        return pool[_task].worker;
    }

    function get_owner(address _task) view public returns (address){
        return pool[_task].owner;
    }

    function get_error_msg(address _task) view public returns (string){
        return pool[_task].error_message;
    }

    function get_fees(address _task) view public returns (uint256 _fee, uint256 _completion_fee){
        return (pool[_task].fee, pool[_task].completion_fee);
    }


    //------------------------------------------------------------------------------------------------------------------
    //Setters
    function create(uint256 _app_id, string _name, string _data, string _script, string _output, string _params, uint256 _fee, address _owner)
    public returns (address _task_address)
    {
        _task_address = generate_address();
        pool[_task_address].app_id = _app_id;
        pool[_task_address].task_name = _name;
        pool[_task_address].data_address = _data;
        pool[_task_address].script_address = _script;
        pool[_task_address].output_address = _output;
        pool[_task_address].parameters = _params;
        pool[_task_address].fee = _fee;
        pool[_task_address].owner = _owner;
        pool[_task_address].create_time = block.number;
    }

    function set_dispatched(address _task, address _worker) distributor_only public returns (bool){
        pool[_task].dispatch_time = block.number;
        pool[_task].worker = _worker;
        return true;
    }

    function set_start(address _task) distributor_only public returns (bool){
        pool[_task].start_time = block.number;
        return true;
    }

    function set_fee(address _task, uint256 _fee) distributor_only public returns (bool){
        pool[_task].fee = _fee;
        return true;
    }

    function set_complete(address _task, uint256 _complete_fee) distributor_only public returns (bool){
        pool[_task].complete_time = block.number;
        pool[_task].completion_fee = _complete_fee;
        return true;
    }

    function set_error(address _task, string _error_msg) distributor_only public returns (bool){
        pool[_task].error_time = block.number;
        pool[_task].error_message = _error_msg;
        return true;
    }

    function set_cancel(address _task) distributor_only public returns (bool){
        pool[_task].cancel_time = block.number;
        return true;
    }

    function set_forfeit(address _task) distributor_only public returns (bool){
        pool[_task].worker = 0;
        pool[_task].dispatch_time = 0;
        pool[_task].start_time = 0;
        pool[_task].complete_time = 0;
        pool[_task].error_time = 0;
        return true;
    }

    function generate_address() internal returns (address){
        return address(bytes20(++nonce));
    }
}