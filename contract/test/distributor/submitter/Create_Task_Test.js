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

    Client.deployed()
        .then(function (instance) {
            return instance.get_client_c();
        }).then(function (result) {
        console.log("Submissible: " + result[3]);
    }).catch(console.log);

    Client.deployed()
        .then(function (instance) {
            return instance.submissible(web3.eth.accounts[0]);
        }).then(function (result) {
        console.log("Submissible: " + result);
    }).catch(console.log);


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
                    console.log(result);
                    console.log("Type of result : " + typeof result);
                    console.log("Test: " + assert(result[1], _name));
                    return Client.deployed();
                })
        }).then(function (instance) {
            instance.get_client_c()
                .then(function (result) {
                    console.log(result);
                    console.log("Submissible : " + result[3]);
                    console.log("Test : " + assert(result[3], false));
                });
            instance.get_active_task();
            return TaskPool.deployed();
        }).then(function (instance) {
            instance.get_status(task_address)
                .then(function (result) {
                    console.log(result);
                });
            instance.nonce().then(function (result) {
                console.log("Nonce " + result);
            });
            instance.get_fees(task_address).then(function (result) {
                console.log("Fee " + result);
            });
            instance.get_owner(task_address).then(function (result) {
                console.log("Owner " + result);
            });
            return Queue_Task.deployed();
        }).then(function (instance) {
            instance.
        }).catch(console.log);
    });
};

function assert(returned, expected) {
    return returned === expected;
}

// 1,"This is test 1","This is data","This is Script","This is output address","A really long parameter list in Json format"
