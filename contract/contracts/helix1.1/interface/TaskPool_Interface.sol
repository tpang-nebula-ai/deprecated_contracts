pragma solidity ^0.4.18;

//@dev for Distributor usage only
interface TaskPoolInterface {
    function create(uint256 _app_id, string _name, string _data, string _script, string _output, string _params, uint256 _fee)
    public returns (address _task_address);

    function get_task(address _task)
    public returns (uint256 _app_id, string _name, string _data, string _script, string _output, string _params);

    function get_status(address _task)
    public returns (uint _create_time, uint dispatch_time, uint start_time, uint complete_time, uint _cancel_time, uint _error_time);

    function get_worker(address _task) public returns (address);

    function get_error_msg(address _task) public returns (string);

    function get_fees(address _task) public returns (uint256 _fee, uint256 _completion_fee);

    function set_dispatched(address _task, address _worker) public;

    function set_start(address _task) public;

    function set_complete(address _task, uint256 _complete_fee) public;

    function set_error(address _task, string _error_msg) public;

    function set_cancel(address _task) public;
}
