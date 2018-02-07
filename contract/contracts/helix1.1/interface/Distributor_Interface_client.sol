pragma solidity ^0.4.18;

interface DistributorInterfaceClient {

    function create_task(
        uint256 _app_id, bytes32 _name, string _data, string _script, string _output, string _params
    ) public payable returns (address);

    function cancel_task(address _task_address) public returns (bool);

    function reassignable() view public returns (bool);

    function reassign_task_request() public returns (bool);

    //@dev is task modification needed

}