/*
 * report Start task and report Complete task
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
    for (let index = 0; index < 8; index++) {
        let _task;
        // let _task_id;
        Accounts.deployed().then(function (instance) {
            return instance.active_job({
                from: web3.eth.accounts[index]
            }).then(function (result) {
                _task = result;
                console.log("worker " + index + " working on " + _task);
                //todo test result not empty
                // return TaskPool.deployed();
                return Distributor.deployed();
            });
        }).then(function (instance) {
            return instance.report_start(
                _task,
                {
                    from: web3.eth.accounts[index]
                }).then(function (result) {
                console.log(index + " : ");
                console.log(result);
                return instance.report_finish(
                    _task,
                    0,
                    {
                        from: web3.eth.accounts[index]
                    }).then(function (result) {
                    console.log(index + " : ");
                    console.log(result);
                    return Accounts.deployed();
                }).catch(console.log);
            }).catch(console.log);
        }).then(function (instance) {
            instance.get_client(web3.eth.accounts[index]).then(console.log);
        }).catch(console.log);
    }
};