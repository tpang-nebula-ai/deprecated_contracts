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


    // Queue_Ai.deployed()
    //     .then(function (instance) {
    //         return instance.pop.estimateGas()
    //             .then(function(result){
    //                 return instance.pop(
    //                     {
    //                         from:Dispatcher.address,
    //                         gas : result
    //                     }).then(function (result) {
    //                         console.log(result);
    //                         instance.queue_status()
    //                             .then(function (result) {
    //                                 console.log("Queue head : " + result[0]);
    //                             console.log("Queue tail : " + result[1]);
    //                             console.log("Queue size : " + result[2]);
    //                             });
    //                     });
    //         });
    //     }).then().catch(console.log);
};