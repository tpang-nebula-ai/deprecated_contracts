pragma solidity ^0.4.18;

interface QueueInterface {
    function has_next() view external returns (bool);

    function size() view external returns (uint);

    function queuer_status(address _address) view external returns (address _prev, address _next, uint _id, uint _curr);

    function push(address _address) public returns (bool);

    function pop() public returns (address);

    function remove(address _address) public returns (bool);

    function insert(address _address, uint _position) public returns (bool);
}
