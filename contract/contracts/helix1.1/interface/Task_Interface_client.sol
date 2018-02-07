pragma solidity ^0.4.18;

///Task related methods

//constructor serves as the create task method
interface TaskInterfaceClient {
    function cancel_task(address _task_address) public returns (bool);

    function reassignable() view public returns (bool);

    function reassign_task_request() public returns (bool);



    //Allow modification???
    //    function modify_task(bytes32 _name, string _data, string _script, string _output, string _params) public returns(bool);
}
