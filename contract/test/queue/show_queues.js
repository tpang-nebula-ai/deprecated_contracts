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
            console.log("Worker Queue");
            instance.show_queue().then(function (result) {
                if (result.length === 0) console.log("Queue Ai Empty");
                else {
                    for (let i = 0; i < result.length; i++) {
                        console.log("Position " + i + " : " + result[i]);
                    }
                }
            }).catch(console.log);
        }).catch(console.log);
    Queue_Task.deployed()
        .then(function (instance) {
            console.log("Task Queue");
            instance.show_queue().then(function (result) {
                if (result.length === 0) console.log("Queue Task Empty");
                else {
                    for (let i = 0; i < result.length; i++) {
                        console.log("Position " + i + " : " + result[i]);
                    }
                }
            }).catch(console.log);
        }).catch(console.log);

};