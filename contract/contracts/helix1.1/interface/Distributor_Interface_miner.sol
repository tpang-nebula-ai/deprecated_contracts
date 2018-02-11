pragma solidity ^0.4.18;

interface DistributorInterfaceMiner {
    //functions
    function report_start(address _task) public returns (bool);

    function report_finish(address _task, uint256 _complete_fee) public returns(bool); //TODO this changed, but not the other files

    function report_error(address _task, string _error_msg) public returns(bool);//TODO this changed but not the other files

    function forfeit(address _task) public returns(bool); //TODO this changed but not the other files
    
}
