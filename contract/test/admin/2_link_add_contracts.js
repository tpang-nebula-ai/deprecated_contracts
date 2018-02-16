let log4js = require('log4js');
log4js.configure({
    appenders: {
        tx: {type: 'file', filename: 'logs/tx_history.log'},
        console: {type: 'console'}
    },
    categories: {default: {appenders: ['tx', 'console'], level: 'info'}}
});

let logger = log4js.getLogger('tx');
let Admin = artifacts.require("Admin");

module.exports = function (deployer) {
    // let admin_address = Admin.address;

    // let admin = Admin.address;

    Admin.web3.eth.getGasPrice(function (error, result) {
        let gasPrice = Number(result);
        console.log("Gas Price is " + result + " wei"); // "10000000000000"

        Admin.deployed()
            .then(function (instance) {
                let admin = instance;
                return admin.set_all.estimateGas()
                    .then(function (result) {
                        let gas = Number(result);
                        console.log("gas estimation = " + gas + " units");
                        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
                        console.log("gas cost estimation = " + Admin.web3.fromWei((gas * gasPrice), 'ether') + " ether");

                        return admin.set_all(
                            {
                                from: Admin.web3.eth.accounts[0],
                                gasPrice: gasPrice,
                                gas: gas
                            })
                    }).then(function (result) {
                        logger.info("Set all : ");
                        logger.info(result);
                    }).catch(console.log);
            }).catch(console.log);
    });
};
