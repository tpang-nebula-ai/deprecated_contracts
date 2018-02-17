pragma solidity ^0.4.18;

import "../../ownership/Dispatchable.sol";
import "../../interface/model/Queue_Interface.sol";

contract Queue is QueueInterface, Dispatchable {
    struct Queuer {
        address prev;
        address next;
        uint256 id;
    }

    struct QueueStruct {
        address head;
        address tail;
        uint256 curr_id;
        uint256 last_id;
        uint256 size;
        mapping(address => Queuer) line;
    }

    QueueStruct queue = QueueStruct(0, 0, 0, 0, 0);

    ///@dev dispatcher not set at constructor
    function Queue(address _admin) public
    Dispatchable(msg.sender, _admin) //set the creator of the contract as owner
    {}



    //helper viewers
    function has_next() view public returns (bool){
        return queue.head != address(0);
    }

    function size() view public returns (uint){
        return queue.size;
    }

    function queuer_status(address _address) view public returns (address _prev, address _next, uint _id, uint _curr){
        return (queue.line[_address].prev, queue.line[_address].next, queue.line[_address].id, queue.curr_id);
    }

    ///@dev function implementation
    function push(address _address) dispatcher_only public returns (bool){
        require(_address != address(0) && _address != queue.head
        && queue.line[_address].prev == address(0) && queue.line[_address].next == address(0));
        if (queue.tail != address(0)) {
            queue.line[queue.tail].next = _address;
            queue.line[_address].prev = queue.tail;
        }
        queue.tail = _address;
        if (queue.head == address(0)) queue.head = _address;
        queue.size++;
        queue.last_id++;
        queue.line[_address].id = queue.last_id;
        return true;
    }

    function pop() dispatcher_only public returns (address){
        require(queue.head != address(0));
        address temp = queue.head;
        queue.head = queue.line[temp].next;
        // address 0 means no more in line
        queue.line[queue.head].prev = 0;
        //house keeping
        queue.size--;
        if (queue.tail == temp) queue.tail = 0;
        queue.line[temp].next = 0;
        //house keeping
        queue.curr_id = queue.line[temp].id;
        // not ++ , because of leaving queue
        queue.line[temp].id = 0;
        // house keeping, all variables in queuer that leaves now are 0s.
        return temp;
    }

    function remove(address _address) dispatcher_only public returns (bool){
        require(queue.head != address(0) || _address == address(0));

        if (queue.head == _address) queue.head = queue.line[queue.head].next;
        if (queue.tail == _address) queue.tail = queue.line[queue.tail].prev;
        if (queue.line[_address].next != address(0)) {
            queue.line[queue.line[_address].next].prev = queue.line[_address].prev;
        }
        if (queue.line[_address].prev != address(0)) {
            queue.line[queue.line[_address].prev].next = queue.line[_address].next;
        }
        queue.size--;
        //house keeping
        queue.line[_address].prev = 0;
        queue.line[_address].next = 0;
        queue.line[_address].id = 0;

        return true;
    }

    //TODO NOT IMPLEMENTED
    function insert(address _address, uint _position) dispatcher_only public returns (bool){
        if (_position >= queue.size) push(_address);
        require(_position <= queue.size);
        _address = 0;
        return true;
    }

    ///@dev to be discussed, emergency usage only owner methods
    function hard_reset_queue() ownerOnly public {
        queue = QueueStruct(0, 0, 0, 0, 0);
        QueueForceReset();
        //TODO to be revisited
    }
    event QueueForceReset();

    //@debug
    function queue_status() public view returns (address _head, address _tail, uint _last_id){
        return (queue.head, queue.tail, queue.last_id);
    }
}

