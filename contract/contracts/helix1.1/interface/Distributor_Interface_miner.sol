pragma solidity ^0.4.18;

contract DistributorInterfaceMiner {
    //getters
    function get_task(address _task)
    view public returns (uint256 _app_id, string _name, string _data, string _script, string _output, string _params);

    function get_status(address _task)
    view public returns (uint _create_time, uint _dispatch_time, uint _start_time, uint _complete_time, uint _cancel_time, uint _error_time);

    function get_worker(address _task) view public returns (address);

    function get_fees(address _task) view public returns (uint256 _fee, uint256 _completion_fee);


    //functions
    function report_start(address _task) public returns (bool);

    function report_finish(address _task, uint256 _complete_fee) public;

    function report_error(address _task, string _error_msg) public;

    function forfeit(address _task) public;
    
}
