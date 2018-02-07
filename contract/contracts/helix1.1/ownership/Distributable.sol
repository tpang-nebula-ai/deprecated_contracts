pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";

contract Distributable is Ownable {
    address public distributor;

    function Distributable(address _owner)
    Ownable(_owner) {}

    function set_distributor(address _distributor) ownerOnly public returns (bool){
        require(_distributor != address(0));
        distributor = _distributor;
        return true;
    }

    modifier distributor_only(){
        require(msg.sender == distributor);
        _;
    }
}
