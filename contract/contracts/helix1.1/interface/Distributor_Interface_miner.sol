pragma solidity ^0.4.18;

contract DistributorInterfaceMiner {
    //functions
    function report_start(address _task) public returns (bool);

    function report_finish(address _task, uint256 _complete_fee) public;

    function report_error(address _task, string _error_msg) public;

    function forfeit(address _task) public;
    
}
