pragma solidity ^0.4.18;
//todo to be continued
import "../../ownership/Administratable.sol";

contract App is Administratable {
    uint256 last_id;

    struct AppInfo {
        uint256 id;
        string name;
        string website;
        address contract_address;
    }

    function App(){}
}
