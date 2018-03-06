pragma solidity ^0.4.18;

interface AccountInterfaceAdmin {
    function set_client(address _client) external returns (bool);

    function set_banned(address _client, bool _banned) external returns (bool);
}
