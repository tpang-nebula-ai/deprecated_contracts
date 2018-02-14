let Queue_Ai = artifacts.require("Queue_Ai");
let Queue_Task = artifacts.require("Queue_Task");
let TaskPool = artifacts.require("TaskPool");
let Accounts = artifacts.require("Accounts");

let Admin = artifacts.require("Admin");

module.exports = function (deployer) {
    let admin = Admin.address;

    deployer.deploy(Queue_Ai, admin);
    deployer.deploy(Queue_Task, admin);
    deployer.deploy(TaskPool, admin, 0);
    deployer.deploy(Accounts, admin);
};