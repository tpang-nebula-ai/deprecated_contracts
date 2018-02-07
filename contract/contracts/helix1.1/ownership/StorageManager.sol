pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";

contract StorageManager is Ownable {
    address public manager;

    function StorageManager(address _owner)
    Ownable(_owner) {}

    function set_manager(address _manager) ownerOnly public returns (bool){
        manager = _manager;
    }

    modifier manager_only(){
        require(msg.sender == manager);
        _;
    }
}
