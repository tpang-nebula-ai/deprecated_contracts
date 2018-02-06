// pragma solidity ^0.4.18;

// import "./TaskInterface.sol";
// import "../nebula_base/Nebula_Interface.sol";

// contract AbstractTask is TaskInterface {

//     address public owner;
//     address public dispatcher;
//     address public worker;

//     //Unique app id
//     uint256 public app_id;
//     //uint256 public app_version;

//     string public task_name;
//     string public data_address;
//     string public script_address;
//     string public output_address;
//     string public parameters;

//     uint public dispatch_time;
//     uint public start_time;
//     uint public complete_time;

//     bool public started;
//     bool public completed;
//     bool public task_issue;
//     bool public cancelled;

//     uint256 minimal_fee = 5 ether;
//     uint256 completion_fee;
//     //for future encryption uses
//     //bytes32 internal worker_public_key;
//     //bytes32 internal task_owner_public_key;


//     function AbstractTask() public{
//         owner = msg.sender;
//     }

//     //Modifiers
//     modifier worker_only(){
//         require(worker == msg.sender);
//         _;
//     }
//     modifier dispatcher_only(){
//         require(dispatcher == msg.sender);
//         _;
//     }
//     modifier worker_only(){
//         require(worker == msg.sender);
//         _;
//     }

//     //Task Owner
//     function createTask(uint256 _app_id, bytes32 _name, string _data, string _script, string _output, string _params, address _dispatcher) internal{
//         //define all the app specific attributes
//         app_id = _app_id;
//         task_name = _name;
//         data_address = _data;
//         script_address = _script;
//         output_address = _output;
//         parameters = _params;
//         dispatcher = _dispatcher;
//         TaskCreated(address(this));
//         join_queue();
//     }
//     //internal
//     function join_queue() internal returns(bool){
//         Nebula_Interface nebula = Nebula_Interface(dispatcher);
//         //TODO use safeMath
//         ///pay a transaction fee to prevent non-sense join queue
//         nebula.join.value(0/*temporarily left empty*/)(address(this));
//     }

//     function cancelTask() public returns (bool){
//         Nebula_Interface nebula = Nebula_Interface(dispatcher);
//         uint toWorker = 0;
//         uint toOwner = this.balance;
//         //TODO
// //        if(worker != address(0)){
// //            toWorker = this.balance.div(3);
// //            toOwner = toOwner.sub(toWorker);
// //            worker.transfer(toWorker);
// //        }
//         TaskCancelled();
// //        nebula.leave(address(this));
// //        owner.transfer(toOwner);
//     }



//     //Task Worker
//     function startTask() worker_only public returns (bool){
//         require(!cancelled && !started);
//         started = true;
//         TaskStarted();
//         return started;
//     }
//     function finishTask() worker_only public returns (bool){
//         require(!cancelled && !finished);
//         finished = true;
//         TaskFinished();
//         return finished;
//     }
//     function reportIssue() worker_only public returns (bool){
//         require(!cancelled && !finished);
//         task_issue = true;
//         TaskFailed();
//         return task_issue;
//     }
//     function forfeitTask() worker_only public returns (bool){
//         require(!cancelled && !finished);

//     }

//     //events
//     //owner
//     event TaskCreated(address indexed _task_address);
//     event TaskCancelled();
//     //dispatcher
//     event TaskDispatched(address indexed _worker_address);
//     event TaskReassigned(address indexed _worker_address);
//     //worker
//     event TaskFailed();
//     event TaskForfeited();
//     event TaskStarted();
//     event TaskCompleted();
// }
