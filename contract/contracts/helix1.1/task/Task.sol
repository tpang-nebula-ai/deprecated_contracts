pragma solidity ^0.4.18;

import "../nebula_base/Nebula_Interface.sol";
import "./AbstractTask.sol";


contract Task is AbstractTask {

    function Task(
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

    function addTaskToQueue() public {
        Nebula_Interface nebula = Nebula_Interface(dispatcher);
        nebula.join.value(msg.value)(address(this));

    }

    //OWNER

    function cancelTask() public returns (bool){
        require(msg.sender == owner);


        TaskCancelled();
        return true;
    }

    //DISPATCHER
    function assignWorker(address _worker_address) public returns (bool){
        require(dispatcher == msg.sender);
        worker = _worker_address;
        WorkerAssigned(worker);
        return true;
    }

    //WORKER

    function startTask() worker_only public returns (bool){

    }

    function reportIssue() worker_only public returns (bool){


        TaskFailed();
        return true;
    }


    function forfeitTask() worker_only public returns (bool){


        TaskForfeited();
        return true;
    }


    function finishTask() worker_only public returns (bool){


        TaskCompleted();
        return true;
    }



}
