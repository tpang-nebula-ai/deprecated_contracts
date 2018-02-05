pragma solidity ^0.4.18;

import "./TaskInterface.sol";

contract AbstractTask is TaskInterface {

    address public owner;
    address public dispatcher;
    address public worker;

    //Unique app id
    uint256 public app_id;
    //uint256 public app_version;

    bytes32 public task_name;
    string public data_address;
    string public script_address;
    string public output_address;
    string public parameters;

    uint public dispatch_time;
    uint public start_time;
    uint public complete_time;

    bool public started;
    bool public completed;
    bool public task_issue;
    bool public cancelled;

    uint256 minimal_fee = 5 ether;
    uint256 completion_fee;

    //for future encryption uses
    //bytes32 internal worker_public_key;
    //bytes32 internal task_owner_public_key;


    //Task Worker
    modifier worker_only(){
        require(worker == msg.sender);
        _;
    }

}
