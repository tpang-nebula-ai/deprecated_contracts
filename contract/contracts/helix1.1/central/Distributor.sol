pragma solidity ^0.4.18;

import "../ownership/Dispatchable.sol";
import "../interface/Dispatcher_Interface_distributor.sol";
import "../interface/Distributor_Interface_client.sol";
import "../interface/TaskPool_Interface_task.sol";



//This layer is necessary for security and control reason
//Otherwise no way to control what are send to task queue while able to keep Task modular
contract Distributor is Dispatchable, TaskPoolInterfaceTask, TaskPoolInterfaceClient {
    uint256 nonce;

    mapping(address => bool) pool;
    DispatcherInterfaceTaskPool nebula;

    ///@dev used to store ALL submitted task
    function Distributor() public Dispatchable(msg.sender) {}


    function generate_address() internal returns (address){
        return address(bytes20(nonce));
    }

    modifier nebula_ready(){
        require(dispatcher != address(0));
        _;
    }
    //@dev override
    function setDispatcher(address _dispatcher) ownerOnly public {
        super.setDispatcher(_dispatcher);
        nebula = DispatcherInterfaceTaskPool(dispatcher);
    }

    function submit_task(uint256 _app_id, bytes32 _name, string _data, string _script, string _output, string _params) nebula_ready public payable returns (address){
        require(dispatcher != address(0));
        Task task = new Task(_app_id, _name, _data, _script, _output, _params, owner, dispatcher);
        pool[task] = true;
        nebula.join(task);
        return address(task);
    }


}