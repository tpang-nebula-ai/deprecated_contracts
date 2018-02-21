/**
 * Create Task Tests
 * Inputs : uint256 _app_id, string _name, string _data, string _script, string _output, string _params
 * Output : address of the newly created task
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
    for (let index = 1; index < 11; index++) {
        A.deployed()
            .then(function (instance) {
                instance.submissible(web3.eth.accounts[0], index).then(function (result) {
                    console.log("App ID " + index + "'s eligibility : ");
                    console.log(result);
                })
            })
            .catch(console.log);
    }
};
