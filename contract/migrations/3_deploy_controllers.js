let Client = artifacts.require("Client");
let Dispatcher = artifacts.require("Dispatcher");
let Distributor = artifacts.require("Distributor");

let Admin = artifacts.require("Admin");

module.exports = function (deployer) {
    let admin = Admin.address;

    deployer.deploy(Client, admin);
    deployer.deploy(Dispatcher, admin);
    deployer.deploy(Distributor, admin, web3.toWei(5, "ether"));
};
