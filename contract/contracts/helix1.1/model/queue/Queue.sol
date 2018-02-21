pragma solidity ^0.4.18;

import "../../misc/SafeMath.sol";
import "../../ownership/Dispatchable.sol";
import "../../interface/model/Queue_Interface.sol";

contract Queue is QueueInterface, Dispatchable {
    using SafeMath for uint256;
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
    function has_next() view external returns (bool){
        return queue.head != address(0);
    }

    function size() view external returns (uint){
        return queue.size;
    }

    function queuer_status(address _address) view external returns (address _prev, address _next, uint _id, uint _curr){
        return (queue.line[_address].prev, queue.line[_address].next, queue.line[_address].id, queue.curr_id);
    }

    function in_queue(address _address) internal view returns (bool){
        return _address == queue.head || queue.line[_address].prev != address(0);
    }

    ///@dev function implementation
    function push(address _address) dispatcher_only public returns (bool){
        require(_address != address(0) && !in_queue(_address));
        if (queue.tail != address(0)) {
            queue.line[queue.tail].next = _address;
            queue.line[_address].prev = queue.tail;
        }
        queue.tail = _address;
        if (queue.head == address(0)) queue.head = _address;
        queue.size = queue.size.add(1);
        queue.last_id = queue.last_id.add(1);
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
        queue.size = queue.size.sub(1);
        if (queue.tail == temp) queue.tail = 0;
        queue.line[temp].next = 0;
        //prev is set to 0, when the prev being popped
        //house keeping
        queue.curr_id = queue.line[temp].id;
        // not ++ , because of leaving queue
        queue.line[temp].id = 0;
        // house keeping, all variables in queuer that leaves now are 0s.
        return temp;
    }

    function remove(address _address) public dispatcher_only returns (bool){
        require(in_queue(_address));

        if (queue.head == _address) queue.head = queue.line[queue.head].next;
        if (queue.tail == _address) queue.tail = queue.line[queue.tail].prev;
        if (queue.line[_address].next != address(0)) {
            queue.line[queue.line[_address].next].prev = queue.line[_address].prev;
        }
        if (queue.line[_address].prev != address(0)) {
            queue.line[queue.line[_address].prev].next = queue.line[_address].next;
        }
        queue.size = queue.size.sub(1);
        //house keeping
        queue.line[_address].prev = 0;
        queue.line[_address].next = 0;
        queue.line[_address].id = 0;
        return true;
    }

    function insert(address _address, uint _position) dispatcher_only public returns (bool){
        require(!in_queue(_address) && _position > 0 && _position <= 5);
        //limited to five to limit gas spent, might need to be changed
        if (_position >= queue.size) {
            push(_address);
        } else {
            address _curr = queue.head;
            for (uint8 i = 1; i < _position; ++i) _curr = queue.line[_curr].next;

            address _curr_next = queue.line[_curr].next;
            queue.line[_curr].next = _address;
            queue.line[_address].prev = _curr;
            queue.line[_address].id = queue.curr_id.add(_position).add(1);
            queue.size = queue.size.add(1);
            if (_curr_next != address(0)) {
                queue.line[_curr_next].prev = _address;
                queue.line[_address].next = _curr_next;
            }
        }
        return true;
    }
    //@dev to be discussed, emergency usage only owner methods
    //    function hard_reset_queue() ownerOnly public {
    //        queue = QueueStruct(0, 0, 0, 0, 0);
    //        QueueForceReset();
    //    }
    //    event QueueForceReset();

    //@debug
    function queue_status() external view returns (address _head, address _tail, uint _last_id){
        return (queue.head, queue.tail, queue.last_id);
    }

    function show_queue() external view returns (address[] _queue){
        if (queue.size != 0) {
            _queue = new address[](queue.size);
            uint256 _index = 0;
            address _curr = queue.head;

            while (_curr != address(0)) {
                _queue[_index++] = _curr;
                _curr = queue.line[_curr].next;
            }
        }
    }
}




