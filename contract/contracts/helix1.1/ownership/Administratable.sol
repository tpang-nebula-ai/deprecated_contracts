pragma solidity ^0.4.18;

import "./Ownable.sol";

contract Administratable is Ownable {
    address public admin_address;
    bool public admin_loaded;
    bool public controller_ready;
    bool public valid; //once invalidated, can no longer be revalidated
    bool public paused;
    function Administratable(address _owner, address _admin) public Ownable(_owner) {
        valid = true;
        if (_admin != address(0)) set_admin(_admin);
    }

    modifier Ready(){
        require(controller_ready && !paused && valid);
        _;
    }

    modifier admin_only(){
        require(msg.sender == admin_address || msg.sender == owner);
        _;
    }
    modifier invalidated_only{
        require(!valid);
        _;
    }

    function set_admin(address _admin) ownerOnly public returns (bool){
        admin_address = _admin;
        admin_loaded = true;
    }

    function pause() ownerOnly external returns (bool){
        return paused = true;
    }

    function invalidate_contract() public ownerOnly returns (bool){
        valid = false;
    }

    //@dev a requirement must be set!!! balance can only be withdrawn when this contract is no longer in use
    function owner_withdraw(uint256 _amount) external ownerOnly invalidated_only returns (uint256){
        owner.transfer(_amount);
    }

    function owner_get_balance() external ownerOnly view returns (uint256){
        return this.balance;
    }
    
    
}
