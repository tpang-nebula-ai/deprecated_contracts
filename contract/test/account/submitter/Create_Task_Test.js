// function create_task(
//     uint256 _app_id, string _name, string _data, string _script, string _output, string _params
// ) public payable returns (address);
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
    let _app_id = 1;
    let _name = "This is test 1";
    let _data = "This is data";
    let _script = "This is Script";
    let _output = "This is output address";
    let _params = "A really long parameter list in Json format";

    Distributor.web3.eth.getGasPrice(function (error, result) {
        let gasPrice = Number(result);
        console.log("Gas Price is " + result + " wei"); // "10000000000000"

        Distributor.deployed()
            .then(function (instance) {
                let distributor = instance;
                return distributor.create_task.estimateGas(_app_id, _name, _data, _script, _output, _params)
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return distributor.create_task(
                            _app_id, _name, _data, _script, _output, _params,
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Distributor#create_task : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
    });
};

