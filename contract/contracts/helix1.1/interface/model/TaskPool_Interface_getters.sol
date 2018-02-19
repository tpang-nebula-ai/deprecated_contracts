pragma solidity ^0.4.18;

interface TaskPoolInterfaceGetter {
    //getter
    function get_task(address _task)
    view external returns (uint256 _app_id, string _name, string _data, string _script, string _output, string _params);

    function get_status(address _task)
    view external returns (uint _create_time, uint _dispatch_time, uint _start_time, uint _complete_time, uint _cancel_time, uint _error_time);

    function reassignable(address _task) view external returns (bool);
}
