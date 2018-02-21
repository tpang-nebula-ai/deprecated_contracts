let Migrations = artifacts.require("Migrations");
let Admin = artifacts.require("Admin");

let Client = artifacts.require("Client");
let Dispatcher = artifacts.require("Dispatcher");
let Distributor = artifacts.require("Distributor");

let Queue_Ai = artifacts.require("Queue_Ai");
let Queue_Task = artifacts.require("Queue_Task");
let TaskPool = artifacts.require("TaskPool");
let Accounts = artifacts.require("Accounts");

let ow = true;

module.exports = function (deployer) {
    deployer.deploy(Migrations, {
        overwrite: ow
    }).then(function () {
        return deployer.deploy(Admin, {
            overwrite: ow
        });
    }).then(function () {
        return deployer.deploy(Distributor, Admin.address, web3.toWei(5, "ether"), {
            overwrite: ow
        });
    }).then(function () {
        return deployer.deploy(Client, Admin.address, {
            overwrite: ow
        });
    }).then(function () {
        return deployer.deploy(Dispatcher, Admin.address, {
            overwrite: ow
        });
    }).then(function () {
        return deployer.deploy(Queue_Ai, Admin.address, {
            overwrite: ow
        });
    }).then(function () {
        return deployer.deploy(Queue_Task, Admin.address, {
            overwrite: ow
        });
    }).then(function () {
        return deployer.deploy(TaskPool, Admin.address, 0, {
            overwrite: ow
        });
    }).then(function () {
        return deployer.deploy(Accounts, Admin.address, {
            overwrite: ow
        });
    }).then(function () {
        let admin_instance;
        return Admin.deployed()
            .then(function (instance) {
                admin_instance = instance;
                return instance.set_all_addresses(
                    Dispatcher.address, Distributor.address, Client.address,
                    Queue_Ai.address, Queue_Task.address, Accounts.address, TaskPool.address);
            }).then(function (result) {
                console.log(result);
                return admin_instance.set_all();
            }).catch(console.log);
    }).then(function (result) {
        console.log(result);
        test();
    }).catch(console.log);
};


function test() {
    console.log("Deployment address tests");
    console.log("Admin @ " + Admin.address);
    console.log("Client @ " + Client.address);
    console.log("Dispatcher @ " + Dispatcher.address);
    console.log("Distributor @ " + Distributor.address);
    console.log("Task Queue @ " + Queue_Task.address);
    console.log("Ai Queue @ " + Queue_Ai.address);
    console.log("Accounts @ " + Accounts.address);
    console.log("TaskPool @ " + TaskPool.address);

    let queue_ai_addr = Queue_Ai.address;
    let queue_task_addr = Queue_Task.address;
    let pool_addr = TaskPool.address;
    let accounts_addr = Accounts.address;

    let client_addr = Client.address;
    let dispatcher_addr = Dispatcher.address;
    let distributor_addr = Distributor.address;

    let admin_addr = Admin.address;

    Admin.deployed().then(function (instance) {
        instance.dispatcher_address().then(function (result) {
            console.log("dispatcher " + result + " " + assert(result, dispatcher_addr));
        });
        instance.distributor_address().then(function (result) {
            console.log("distributor " + result + " " + assert(result, distributor_addr));
        });
        instance.client_address().then(function (result) {
            console.log("client " + result + " " + assert(result, client_addr));
        });
        instance.taskpool_address().then(function (result) {
            console.log("taskpool " + result + " " + assert(result, pool_addr));
        });
        instance.queue_ai_address().then(function (result) {
            console.log("queue ai " + result + " " + assert(result, queue_ai_addr));
        });
        instance.queue_task_address().then(function (result) {
            console.log("queue task " + result + " " + assert(result, queue_task_addr));
        });
        instance.account_address().then(function (result) {
            console.log("account " + result + " " + assert(result, accounts_addr));
        });
    }).catch(console.log);

    Client.deployed().then(function (instance) {
        correct_controllers(instance, "client")
    });
    Distributor.deployed().then(instance => correct_controllers(instance, "distributor"));
    Dispatcher.deployed().then(instance => correct_dispatcher(instance, "dispatcher"));

    TaskPool.deployed().then(instance => {
        correct_admin(instance, "Task Pool");
        correct_distributor(instance, "Task Pool");
    });
    Queue_Ai.deployed().then(instance => {
        correct_admin(instance, "Queue Ai");
        correct_dispatcher(instance, "Queue Ai");
    });
    Queue_Task.deployed().then(instance => {
        correct_admin(instance, "Queue Task");
        correct_dispatcher(instance, "Queue Task");
    });
    Accounts.deployed().then(instance => {
        correct_admin(instance, "Account");
        correct_client(instance, "Account");
    });

    function correct_admin(instance, contract) {
        instance.admin_address().then(function (result) {
            console.log(contract + "'s admin @ " + result + " " + assert(result, admin_addr))
        }).catch(console.log);
    }

    function correct_controllers(instance, controller) {
        correct_admin(instance, controller);
        correct_dispatcher(instance, controller);
        correct_distributor(instance, controller);
        correct_client(instance, controller);
    }

    function correct_dispatcher(instance, contract) {
        instance.dispatcher_address().then(function (result) {
            console.log(contract + "'s dispatcher @ " + result + " " + assert(result, dispatcher_addr))
        }).catch(console.log);
    }

    function correct_distributor(instance, contract) {
        instance.distributor_address().then(function (result) {
            console.log(contract + "'s distributor @ " + result + " " + assert(result, distributor_addr))
        }).catch(console.log);
    }

    function correct_client(instance, contract) {
        instance.client_address().then(function (result) {
            console.log(contract + "'s client @ " + result + " " + assert(result, client_addr))
        }).catch(console.log);
    }

    function assert(returned, expected) {
        return returned === expected;
    }
}
