// function cancel_task(address _task) public returns (bool);
/**
 * Create Task Tests
 * Inputs : address task to cancel address
 * Output : result
 * Payable !
 *
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
    let task_to_cancel;

    Accounts.deployed()
        .then(function (instance) {
            return instance.active_tasks()
                .then(function (result) {
                    if (result.length === 0) throw new Error("No active Task");
                    console.log("Task to be cancelled : " + result[0]);
                    task_to_cancel = result[0];
                    return Distributor.deployed();
                });
        }).then(function (instance) {
        return instance.cancel_task(task_to_cancel)
            .then(function (result) {
                console.log("Task Cancellation Result:");
                console.log(result);
                return TaskPool.deployed();
            });
    }).then(function (instance) {
        return instance.get_task(task_to_cancel)
            .then(function (result) {
                console.log("Get task " + task_to_cancel);
                console.log("App Id : " + result[0]);
                console.log("Task name : " + result[1]);
                console.log("Task data address : " + result[2]);
                console.log("Task script address : " + result[3]);
                console.log("Task output address : " + result[4]);
                console.log("Task optional parameters : " + result[5]);
                return Client.deployed();
            });
    }).then(function (instance) {
        instance.get_client_c()
            .then(function (result) {
                console.log("Client Banned : " + result[0]);
                console.log("Misconduct Counter : " + result[1]);
                console.log("Client Level : " + result[2]);
                console.log("Submissible : " + result[3]);
                console.log("Submissible correctness: ");
                console.log(result[3] === true);
            });
        return Accounts.deployed();
    }).then(function (instance) {
        instance.task_history().then(function (result) {
            console.log("Task History");
            console.log(result);
        }).catch(console.log);
        instance.active_tasks().then(function (result) {
            console.log("Active Task");
            console.log(result);
            console.log("Active Task is empty ");
            console.log(result.length === 0);
        }).catch(console.log);
        return TaskPool.deployed();
    }).then(function (instance) {
        instance.get_status(task_to_cancel).then(function (result) {
            console.log("Task Status");
            console.log("Task Created @ " + result[0]);
            console.log("Task Dispatched @ " + result[1]);
            console.log("Task Started @ " + result[2]);
            console.log("Task Completed @ " + result[3]);
            console.log("Task Cancelled @ " + result[4]);
            console.log("Task Error @ " + result[5]);
            console.log("Task Has been cancelled : ");
            console.log(Number(result[4]) !== 0);
        }).catch(console.log);
        instance.nonce().then(function (result) {
            console.log("Nonce " + result);
        }).catch(console.log);
        instance.get_fees(task_to_cancel).then(function (result) {
            console.log("Fee " + result[0]);
            console.log("Completion Fee " + result[1]);
            console.log("Fee is 0 : ");
            console.log(Number(result[0]) === 0);
        }).catch(console.log);
        instance.get_owner(task_to_cancel).then(function (result) {
            console.log("Owner " + result);
        }).catch(console.log);
        return Queue_Task.deployed();
    }).then(function (instance) {
        instance.queue_status().then(function (result) {
            console.log("Queue head : " + result[0]);
            console.log("Queue tail : " + result[1]);
            console.log("Queue Last Id : " + result[2]);
        });
    }).catch(console.log);
};