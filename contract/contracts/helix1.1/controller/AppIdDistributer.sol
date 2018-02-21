pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";

contract IdDistributor is Ownable {

    uint256 public last_id;

    struct AppInfo {
        address app_owner;
        bool valid;
        string name;
        string website;
        address contract_address;
    }

    mapping(uint256 => AppInfo) apps;

    function IdDistributor(uint256 _starting_id) public Ownable(msg.sender) {
        last_id = _starting_id;
    }

    function new_app(string _name, string _website_address, address _contract_address) external returns (uint _app_id){
        last_id++;
        apps[last_id].valid = true;
        apps[last_id].name = _name;
        apps[last_id].website = _website_address;
        apps[last_id].contract_address = _contract_address;

        return last_id;
    }
    modifier app_owner_only(uint256 _id) {
        require(msg.sender == apps[_id].app_owner);
        _;
    }

    function update_app_name(uint256 _id, string _name) external app_owner_only(_id) returns (bool){
        apps[_id].name = _name;
        return true;
    }

    function update_app_website(uint256 _id, string _web) external app_owner_only(_id) returns (bool){
        apps[_id].website = _web;
        return true;
    }

    function update_app_contract_address(uint256 _id, address _contract_address) external app_owner_only(_id) returns (bool){
        apps[_id].contract_address = _contract_address;
        return true;
    }

    function invalidate_app(uint256 _id) external app_owner_only(_id) returns (bool){
        apps[_id].valid = false;
        return true;
    }

    function is_app_valid(uint256 _id) external view returns (bool){
        return apps[_id].valid;
    }
}