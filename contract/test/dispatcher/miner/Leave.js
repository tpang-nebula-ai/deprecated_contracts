// function leave_ai_queue() public returns (bool);
/**
 * Leave Ai Queue
 * Inputs :
 * Output : result
 * @see Dispatcher#leave_ai_queue()
 * @return bool _successful
 *
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
    Queue_Ai.deployed()
        .then(function (instance) {
            return instance.queue_status().then(function (result) {
                console.log("Queue head : " + result[0]);
                console.log("Queue tail : " + result[1]);
                console.log("Queue Last Id : " + result[2]);
                return Client.deployed();
            });
        }).then(function (instance) {
        console.log("Leaving AI Queue");
        return instance.get_client_m()
            .then(function (result) {
                console.log("Eligible " + result[0]);
                console.log("Waiting " + result[1]);
                console.log("Working " + result[2]);
                console.log("Banned " + result[3]);
                console.log("Misconduct counter " + result[4]);
                if (result[3]) throw new Error("Client is Banned");
                if (!result[0]) throw new Error("Client is not eligible");
                if (result[2]) throw new Error("Client is working, cannot leave queue");
                if (!result[1]) throw new Error("Client is not waiting");

                return Dispatcher.deployed();
            });
    }).then(function (instance) {
        return instance.leave_ai_queue()
            .then(function (result) {
                console.log(result);

                return Client.deployed();
            });
    }).then(function (instance) {
        return instance.get_client_m().then(function (result) {
            console.log("Eligible " + result[0]);
            console.log("Waiting " + result[1]);
            console.log("Working " + result[2]);
            console.log("Banned " + result[3]);
            console.log("Misconduct counter " + result[4]);
            return Queue_Ai.deployed();
        });
    }).then(function (instance) {
        return instance.queue_status().then(function (result) {
            console.log("Queue head : " + result[0]);
            console.log("Queue tail : " + result[1]);
            console.log("Queue Last Id : " + result[2]);
        }).then(console.log).catch(console.log);
    });
};