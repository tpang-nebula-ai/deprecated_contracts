let log4js = require('log4js');
log4js.configure({
    appenders: {
        tx: {type: 'file', filename: 'logs/tx_history.log'},
        console: {type: 'console'}
    },
    categories: {default: {appenders: ['tx', 'console'], level: 'info'}}
});

let logger = log4js.getLogger('tx');

let Queue_Ai = artifacts.require("Queue_Ai");
let Queue_Task = artifacts.require("Queue_Task");
let TaskPool = artifacts.require("TaskPool");
let Accounts = artifacts.require("Accounts");

let Client = artifacts.require("Client");
let Dispatcher = artifacts.require("Dispatcher");
let Distributor = artifacts.require("Distributor");

let Admin = artifacts.require("Admin");

module.exports = function (deployer) {
    console.log("Admin @ " + Admin.address);
    console.log("Client @ " + Client.address);
    console.log("Dispatcher @ " + Dispatcher.address);
    console.log("Distributor @ " + Distributor.address);
    console.log("Task Queue @ " + Queue_Task.address);
    console.log("Task Ai @ " + Queue_Ai.address);
    console.log("Accounts @ " + Accounts.address);
    console.log("TaskPool @ " + TaskPool.address);


    let queue_ai = Queue_Ai.address;
    let queue_task = Queue_Task.address;
    let pool = TaskPool.address;
    let accounts = Accounts.address;

    let client = Client.address;
    let dispatcher = Dispatcher.address;
    let distributor = Distributor.address;

    // let admin = Admin.address;

    Admin.web3.eth.getGasPrice(function (error, result) {
        let gasPrice = Number(result);
        console.log("Gas Price is " + result + " wei"); // "10000000000000"

        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_distributor_address.estimateGas(distributor)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_distributor_address(
                            distributor,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Distributor : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_dispatcher_address.estimateGas(dispatcher)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_dispatcher_address(
                            dispatcher,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Dispatcher : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_client_address.estimateGas(client)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_client_address(
                            cleint,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Client : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_task_queue_address.estimateGas(queue_task)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_task_queue_address(
                            queue_task,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Task Queue : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_ai_queue_address.estimateGas(queue_ai)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_ai_queue_address(
                            queue_ai,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Ai Queue : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_taskpool_address.estimateGas(pool)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_taskpool_address(
                            pool,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Task Pool : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_account_address.estimateGas(accounts)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_account_address(
                            accounts,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Accounts : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
    });
};
