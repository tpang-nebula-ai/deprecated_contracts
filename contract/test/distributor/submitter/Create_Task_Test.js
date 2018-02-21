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

        let task_address;

        Distributor.deployed()
            .then(function (instance) {
                let distributor = instance;
                return distributor.create_task.estimateGas(_app_id, _name, _data, _script, _output, _params,
                    {
                        from: Admin.web3.eth.accounts[0],
                        value: Admin.web3.toWei(5, "ether")
                    })
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return distributor.create_task(
                            _app_id, _name, _data, _script, _output, _params,
                            {
                                from: Admin.web3.eth.accounts[0],
                                value: Admin.web3.toWei(5, "ether"),
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Distributor#create_task : ");
                        logger.info(result);
                        task_address = result.logs[0].args["_task"];
                        logger.info("Return: " + task_address);
                        return TaskPool.deployed();
                    })
            }).then(function (instance) {
            return instance.get_task(task_address)
                .then(function (result) {
                    console.log("Get task " + task_address);
                    console.log("App Id : " + result[0]);
                    console.log("Task name : " + result[1]);
                    console.log("Task data address : " + result[2]);
                    console.log("Task script address : " + result[3]);
                    console.log("Task output address : " + result[4]);
                    console.log("Task optional parameters : " + result[5]);
                    console.log("Test: " + assert(result[1], _name));
                    return Client.deployed();
                })
        }).then(function (instance) {
            instance.get_client_c()
                .then(function (result) {
                    console.log("Client Banned : " + result[0]);
                    console.log("Misconduct Counter : " + result[1]);
                    console.log("Client Level : " + result[2]);
                    console.log("Submissible : " + result[3]);
                    console.log("Submissible correctness: ");
                    console.log(result[3] === false);
                });
            return Accounts.deployed();
        }).then(function (instance) {
            instance.task_history(_app_id).then(function (result) {
                console.log("Task History");
                console.log(result);
            });
            instance.active_tasks(_app_id).then(function (result) {
                console.log("Active Task");
                console.log(result);
                console.log("Active Task is empty ");
                console.log(result.length === 1);
            });
            return TaskPool.deployed();
        }).then(function (instance) {
            instance.get_status(task_address).then(function (result) {
                console.log("Task Status");
                console.log("Task Created @ " + result[0]);
                console.log("Task Dispatched @ " + result[1]);
                console.log("Task Started @ " + result[2]);
                console.log("Task Completed @ " + result[3]);
                console.log("Task Cancelled @ " + result[4]);
                console.log("Task Error @ " + result[5]);
                console.log("Task Has been created : ");
                console.log(Number(result[0]) !== 0);
            });
            instance.nonce().then(function (result) {
                console.log("Nonce " + result);
            });
            instance.get_fees(task_address).then(function (result) {
                console.log("Fee " + result[0]);
                console.log("Completion Fee " + result[1]);
                console.log("Fee is 5 : ");
                console.log(Number(result[0]) === Admin.web3.toWei(5, "ether"));
            });
            instance.get_owner(task_address).then(function (result) {
                console.log("Owner " + result);
            });
            return Queue_Task.deployed();
        }).then(function (instance) {
            instance.queue_status().then(function (result) {
                console.log("Queue head : " + result[0]);
                console.log("Queue tail : " + result[1]);
                console.log("Queue Last Id : " + result[2]);
            });
        }).catch(console.log);
    });
};

function assert(returned, expected) {
    return returned === expected;
}
