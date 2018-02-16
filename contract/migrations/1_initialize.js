let Migrations = artifacts.require("Migrations");
let Admin = artifacts.require("Admin");

let Client = artifacts.require("Client");
let Dispatcher = artifacts.require("Dispatcher");
let Distributor = artifacts.require("Distributor");

let Queue_Ai = artifacts.require("Queue_Ai");
let Queue_Task = artifacts.require("Queue_Task");
let TaskPool = artifacts.require("TaskPool");
let Accounts = artifacts.require("Accounts");

module.exports = function (deployer) {
    deployer
        .deploy(Migrations, {
            overwrite: true
        }).then(function () {
        return deployer.deploy(Admin, {
            overwrite: true
        });
    }).then(function () {
        return deployer.deploy(Client, Admin.address, {
            overwrite: true
        });
    }).then(function () {
        return deployer.deploy(Dispatcher, Admin.address, {
            overwrite: true
        });
    }).then(function () {
        return deployer.deploy(Distributor, Admin.address, web3.toWei(5, "ether"), {
            overwrite: true
        });
    }).then(function () {
        return deployer.deploy(Queue_Ai, Admin.address, {
            overwrite: true
        });
    }).then(function () {
        return deployer.deploy(Queue_Task, Admin.address, {
            overwrite: true
        });
    }).then(function () {
        return deployer.deploy(TaskPool, Admin.address, 0, {
            overwrite: true
        });
    }).then(function () {
        return deployer.deploy(Accounts, Admin.address, {
            overwrite: true
        });
    }).then(function () {

        console.log("Admin @ " + Admin.address);
        console.log("Client @ " + Client.address);
        console.log("Dispatcher @ " + Dispatcher.address);
        console.log("Distributor @ " + Distributor.address);
        console.log("Task Queue @ " + Queue_Task.address);
        console.log("Task Ai @ " + Queue_Ai.address);
        console.log("Accounts @ " + Accounts.address);
        console.log("TaskPool @ " + TaskPool.address);

        let admin_instance;

        return Admin.deployed()
            .then(function (instance) {
                admin_instance = instance;
                return instance.set_all_addresses(
                    Dispatcher.address, Distributor.address, Client.address,
                    Queue_Ai.address, Queue_Task.address, Accounts.address, TaskPool.address);
            }).then(function (result) {
                console.log(result);
                return admin_instance.set_all();
            });
    }).then(console.log).catch(console.log);
};
