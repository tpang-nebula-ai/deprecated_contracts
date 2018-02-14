let log4js = require('log4js');
log4js.configure({
    appenders: {
        tx: {type: 'file', filename: 'logs/tx_history.log'},
        console: {type: 'console'}
    },
    categories: {default: {appenders: ['tx', 'console'], level: 'info'}}
});

let logger = log4js.getLogger('tx');

let Migrations = artifacts.require("Migrations");
let Admin = artifacts.require("Admin");

let Client = artifacts.require("Client");
let Dispatcher = artifacts.require("Dispatcher");
let Distributor = artifacts.require("Distributor");

let Queue_Ai = artifacts.require("Queue_Ai");
let Queue_Task = artifacts.require("Queue_Task");
let TaskPool = artifacts.require("TaskPool");
let Accounts = artifacts.require("Accounts");

module.exports = function (callback) {

    console.log("Admin @ " + Admin.address);
    console.log("Client @ " + Client.address);
    console.log("Dispatcher @ " + Dispatcher.address);
    console.log("Distributor @ " + Distributor.address);
    console.log("Task Queue @ " + Queue_Task.address);
    console.log("Task Ai @ " + Queue_Ai.address);
    console.log("Accounts @ " + Accounts.address);
    console.log("TaskPool @ " + TaskPool.address);
    //
    //

    let queue_ai = Queue_Ai.address;
    let queue_task = Queue_Task.address;
    let pool = TaskPool.address;
    let accounts = Accounts.address;

    let client = Client.address;
    let dispatcher = Dispatcher.address;
    let distributor = Distributor.address;

    // let admin = Admin.address;

    Admin.deployed().then(function (instance) {
        instance.dispatcher_address().then(function (result) {
            console.log("dispatcher " + result + " " + assert(result, dispatcher));
        });
        instance.distributor_address().then(function (result) {
            console.log("distributor " + result + " " + assert(result, distributor));
        });
        instance.client_address().then(function (result) {
            console.log("client " + result + " " + assert(result, client));
        });
        instance.taskpool_address().then(function (result) {
            console.log("taskpool " + result + " " + assert(result, pool));
        });
        instance.queue_ai_address().then(function (result) {
            console.log("queue ai " + result + " " + assert(result, queue_ai));
        });
        instance.queue_task_address().then(function (result) {
            console.log("queue task " + result + " " + assert(result, queue_task));
        });
        instance.account_address().then(function (result) {
            console.log("account " + result + " " + assert(result, accounts));
        });
    });

    Admin.web3.eth.getGasPrice(function (error, result) {
        let gasPrice = Number(result);
        console.log("Gas Price is " + result + " wei"); // "10000000000000"

        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_all.estimateGas()
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_all(
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Set all : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
    });
};

function assert(returned, expected) {
    return returned === expected;
}
