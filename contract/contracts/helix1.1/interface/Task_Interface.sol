pragma solidity ^0.4.18;

///Task related methods

//Task contract should be as light as possible
///Interface is designated for other contract to use mostly, e.g. Nebula main contract to use. This should be limited
///to fewest functions if possible

//constructor serves as the create task method
interface TaskInterface {



    //Task Dispatcher
    function dispatchTask(address _worker_address) public returns (bool);
    function reassignTask(address _worker_address) public returns (bool);





}
