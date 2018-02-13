class Deployer {

    constructor() {
        const Web3 = require("web3");
        this.web3 = new Web3("http://127.0.0.1:8545");
    }

    unlock_account_coinbase() {
        this.web3.eth.getAccounts().then(account => {
            this.web3.eth.defaultAccount = account[0];
            const pw = require("./password.json");
            this.web3.eth.personal.unlockAccount(this.web3.eth.defaultAccount, pw.coinbase, 100000)
                .then((result) => {
                    console.log("Wallet " + this.web3.eth.defaultAccount + " has " + (result ? "" : "Not ") + "been unlocked");
                    if (result) load_contracts();
                });
        }).catch(console.log);
    }
}

const deployer = new Deployer();
deployer.unlock_account_coinbase();


const files = require("./file.json");

class NebulaContract {
    constructor(file) {
        let json = require(file);
        // console.log(json);
    }

    deploy() {

    }
}

const CONTRACTS = {
    admin: new NebulaContract(files.admin),
    client: new NebulaContract(files.client),
    dispatcher: new NebulaContract(files.dispatcher),
    distributor: new NebulaContract(files.distributor),
    queue_ai: new NebulaContract(files.queue),
    queue_task: new NebulaContract(files.queue),
    accounts: new NebulaContract(files.account),
    taskpool: new NebulaContract(files.taskpool)
};

function load_contracts() {
    console.log("Loading contract json files");

}


let admin = new NebulaContract("../build/contracts/Admin.json");
