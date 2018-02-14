Web3 = require("web3");
web3 = new Web3("http://127.0.0.1:8545");

let json_loaded = false;


class NebulaContract {
    constructor(file) {
        this.variables();
        this.json_file_path = file;
        this.json_contract = require(this.json_file_path);
    }

    variables() {
        this.json_file_path = "";
        this.json_contract = {};
        this.contract = {};
        this.address = "";
    }

    create_contract() {
        this.contract = new web3.eth.Contract(
            this.json_contract.abi,
            {
                from: web3.eth.defaultAccount,
                data: this.json_contract.bytecode,
            });
        return this;
    }

    estimate_gas(args) {
        args = args || {};
        return this.contract
            .deploy({
                arguments: args
            }).estimateGas()
            .then(result => {
                this.contract.options.gas = result;
            })
            .catch(console.log);
    }

    migrate(args) {
        if (this.contract.options.gas < 4100000) {
            args = args || {};


            return this.contract.deploy({
                arguments: args
            }).send({
                from: this.contract.options.from,
                gas: this.contract.options.gas,
                gasPrice: this.contract.options.gasPrice
            }, function (error, result) {
                if (error) console.log(error);
                else console.log("Migrate result : " + result);
            }).on('error', function (error) {
                console.log(error);
            }).on('transactionHash', function (transactionHash) {
                console.log(transactionHash);
            }).on('receipt', function (receipt) {
                console.log(receipt.contractAddress); // contains the new contract address
            });
        } else {
            throw new Error("Gas Price exceeded limit");
        }
    }
}


class Deployer {
    constructor() {
        this.variables();
        this.unlock_coinbase();
    }

    variables() {
        this.unlocked = false;
        this.CONTRACTS = {
            admin: {},
            client: {},
            dispatcher: {},
            distributor: {},
            queue_ai: {},
            queue_task: {},
            accounts: {},
            taskpool: {}
        };
    }

    // deploy() {
    //     this.unlock_coinbase();
    // }

    unlock_coinbase() {
        let _this = this;
        return web3.eth.getAccounts().then(result => {
            if (result.length === 0) throw new Error("Account list is empty");
            web3.eth.defaultAccount = result[0];
            const pw = require("./password.json");
            return web3.eth.personal.unlockAccount(web3.eth.defaultAccount, pw.coinbase, 100000).then(
                result => {
                    if (result) {
                        _this.unlocked = true;
                        _this.load_contracts();
                        _this.deploy_admin().then(function (admin_instance) {
                            _this.CONTRACTS.admin.instance = admin_instance;


                        }).catch(console.log);
                    } else throw new Error("User account not unlocked")
                });
        });
    }


    // unlock_coinbase(){
    //     return web3.eth.getAccounts().then(account => {
    //         web3.eth.defaultAccount = account[0];
    //         const pw = require("./password.json");
    //         web3.eth.personal.unlockAccount(web3.eth.defaultAccount, pw.coinbase, 100000)
    //             .then((result) => {
    //                 console.log("Wallet " + web3.eth.defaultAccount + " has " + (result ? "" : "Not ") + "been unlocked");
    //                 if (result) {
    //                     this.unlocked = true;
    //                     this.load_contracts();
    //                 }else throw new Error("User account not unlocked");
    //             });
    //     }).catch(console.log);
    // }

    load_contracts() {
        if (!this.unlocked) throw new Error("User account not unlocked");

        console.log("Loading contract json files");

        const files = require("./file.json");

        this.CONTRACTS.admin = new NebulaContract(files.admin);
        this.CONTRACTS.client = new NebulaContract(files.client);
        this.CONTRACTS.dispatcher = new NebulaContract(files.dispatcher);
        this.CONTRACTS.distributor = new NebulaContract(files.distributor);
        this.CONTRACTS.queue_ai = new NebulaContract(files.queue);
        this.CONTRACTS.queue_task = new NebulaContract(files.queue);
        this.CONTRACTS.accounts = new NebulaContract(files.account);
        this.CONTRACTS.taskpool = new NebulaContract(files.taskpool);

        console.log("Contracts loaded");
    }

    deploy_admin() {
        return this.CONTRACTS.admin.create_contract().estimate_gas({arguments: "aaabbbccc"}).then(result => {
            this.CONTRACTS.admin.contract.gasPrice = result;
            return this.CONTRACTS.admin.migrate();
        });
    }

}

const deployer = new Deployer();



