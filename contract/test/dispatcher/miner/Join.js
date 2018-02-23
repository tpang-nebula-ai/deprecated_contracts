// function join_ai_queue() public returns (bool);
/**
 * Join Ai Queue
 * Inputs :
 * Output : result
 */
//Prepare the contracts and load the logger
let log4js = require('log4js');
log4js.configure({
    appenders: {
        tx: {type: 'file', filename: 'logs/create_task_test.log'},
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

module.exports = function (callback) {
    for (let i = 0; i < 8; i++) {
        Queue_Ai.deployed()
            .then(function (instance) {
                return instance.queue_status().then(function (result) {
                    console.log("Queue head : " + result[0]);
                    console.log("Queue tail : " + result[1]);
                    console.log("Queue Last Id : " + result[2]);
                    return Client.deployed();
                });
            }).then(function (instance) {
            console.log("Joining AI Queue");
            return instance.get_client_m(
                {
                    from: web3.eth.accounts[i]
                }).then(function (result) {
                console.log("Eligible " + result[0]);
                console.log("Waiting " + result[1]);
                console.log("Working " + result[2]);
                console.log("Banned " + result[3]);
                console.log("Misconduct counter " + result[4]);

                if (result[3]) throw new Error("Miner is Banned");
                if (result[1]) throw new Error("Miner is already in queue");
                if (result[2]) throw new Error("Miner is working");
                if (!result[0]) {
                    console.log("Applying for eligibility");
                    return instance.apply_eligibility(
                        {
                            from: web3.eth.accounts[i],
                            value: web3.toWei(15, "ether")
                        }).then(function (result) {
                        if (result) {
                            console.log("Miner Eligibility Granted");
                            return Dispatcher.deployed();
                        }
                        else throw new Error("Eligibility Application failed");
                    })
                } else return Dispatcher.deployed();
            })
        }).then(function (instance) {
            console.log("Joining AI Queue");
            return instance.join_ai_queue(
                {
                    from: web3.eth.accounts[i]
                }).then(function (result) {
                console.log(result);
                return Queue_Ai.deployed();
            });
        }).then(function (instance) {
            return instance.queue_status().then(function (result) {
                console.log("Queue head : " + result[0]);
                console.log("Queue tail : " + result[1]);
                console.log("Last ID in queue : " + result[2]);
                return Client.deployed();
            });
        }).then(function (instance) {
            console.log("Joining AI Queue Result");
            return instance.get_client_m(
                {
                    from: web3.eth.accounts[i]
                }).then(function (result) {
                console.log("Eligible " + result[0]);
                console.log("Waiting " + result[1]);
                console.log("Working " + result[2]);
                console.log("Banned " + result[3]);
                console.log("Misconduct counter " + result[4]);
            });
        }).catch(console.log);
    }
};