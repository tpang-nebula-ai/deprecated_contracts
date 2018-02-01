pragma solidity ^0.4.18;

import "../nebula_base/Nebula_Base.sol";

contract Task_Template {

    address public owner;
    address public dispatcher;
    address public worker;

    //Unique app id
    uint256 public app_id;
    //    uint256 public app_version;

    bytes32 public task_name;
    string public data_address;
    string public script_address;
    string public output_address;
    string public parameters;

    bool public started;
    bool public completed;
    bool public task_issue;
    bool public cancelled;

    uint256 minimal_fee = 5 ether;
    uint256 completion_fee;



    //for future encryption uses
    //bytes32 internal worker_public_key;
    //bytes32 internal task_owner_public_key;

    function Task_Template(
        uint256 _app_id,
        bytes32 _name,
        string _data,
        string _script,
        string _output,
        string _params,
        address _dispatcher
    ) public payable {
        require(msg.value >= minimal_fee);
        //define all the app specific attributes
        app_id = _app_id;

        //define all the task specific attributes
        owner = msg.sender;
        dispatcher = _dispatcher;
        task_name = _name;
        data_address = _data;
        script_address = _script;
        output_address = _output;
        parameters = _params;
        //all bool are false by default
    }

    function addTaskToQueue() internal {
        Nebula_Base nebula = Nebula_Base(dispatcher);
        nebula.join.value(msg.value)(address(this));

    }

    //OWNER

    function cancelTask() public returns (bool){
        require(msg.sender == owner);


        TaskCancelled();
        return true;
    }

    event TaskCancelled();

    //DISPATCHER
    function assignWorker(address _worker_address) public returns (bool){
        require(dispatcher == msg.sender);
        worker = _worker_address;
        WorkerAssigned(worker);
        return true;
    }

    event WorkerAssigned(address indexed _worker_address);

    //WORKER
    modifier worker_only(){
        require(worker == msg.sender);
        _;
    }

    function startTask() worker_only public returns (bool){

    }

    function reportIssue() worker_only public returns (bool){


        TaskFailed();
        return true;
    }

    event TaskFailed();

    function forfeitTask() worker_only public returns (bool){


        TaskForfeited();
        return true;
    }

    event TaskForfeited();

    function finishTask() worker_only public returns (bool){


        TaskCompleted();
        return true;
    }

    event TaskCompleted();


}
