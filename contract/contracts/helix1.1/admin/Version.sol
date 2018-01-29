pragma solidity ^0.4.18;

import "../ownership/Owner";

// To simplify version/release tracking and simply version changes, let Dapp to track Version and get the address of
// the newest contract from Version
contract Version is Ownable {

    address[] public address_list;

    address public current_address;

    function Version()
    Ownable(msg.sender)
    {}

    function releaseNewVersion(address _new_address) ownerOnly public {
        require(_new_address != address(0));
        version_list.push(_new_address);
        current_version = _new_address;
    }
}
