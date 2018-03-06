let Queue_Ai = artifacts.require("Queue_Ai");
let Queue_Task = artifacts.require("Queue_Task");
let TaskPool = artifacts.require("TaskPool");
let Accounts = artifacts.require("Accounts");

let Client = artifacts.require("Client");
let Dispatcher = artifacts.require("Dispatcher");
let Distributor = artifacts.require("Distributor");

let Admin = artifacts.require("Admin");

let banned_account = "0x3853d6c71DC8133aA7140e7705F793a06D184893";
let to_ban = false;

module.exports = function (deployer) {
    Accounts.deployed()
        .then(
            (instance) => {
                let acc_instance = instance;
                console.log("Set ", banned_account, "to be banned as ", to_ban);
                return acc_instance.set_banned.estimateGas(
                    banned_account,
                    to_ban
                ).then(result => {
                    let gas = Number(result);

                    return acc_instance.set_banned(
                        banned_account,
                        to_ban,
                        {
                            from: Accounts.web3.eth.accounts[0],
                            gas: gas
                        })
                });
            })
        .then(console.log)
        .catch(console.log);
};