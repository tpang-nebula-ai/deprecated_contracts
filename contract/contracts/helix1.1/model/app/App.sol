pragma solidity ^0.4.18;
//todo to be continued
contract App {
    uint256 last_id;

    struct AppInfo {
        uint256 id;
        string name;
        string website;
        address contract_address;
    }

    function App() is Administratable{

}
}
