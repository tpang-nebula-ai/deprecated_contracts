pragma solidity ^0.4.18;

contract TaskInterfaceMiner {
    function report_start(address _task) public returns (bool);

    function report_finish(address _task) public returns (bool);

    function report_error(address _task) public returns (bool);

    function forfeit(address _task) public returns (bool);
}
