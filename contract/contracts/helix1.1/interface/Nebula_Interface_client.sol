pragma solidity ^0.4.18;

interface NebulaInterfaceClient {
    
    function submit_task(uint256 _app_id, bytes32 _name, string _data, string _script, string _output, string _params) public payable returns(address);

    function cancel_task(address _task_address) public returns(bool);
}