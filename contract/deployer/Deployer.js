let Web3 = require('web3');

let web3 = new Web3(Web3.givenProvider || "http://127.0.0.1:8545");

let personal = web3.eth.personal;
personal.defaultAccount = "0x04443827409B356555feF22F76Efb91996f47d3E";
personal.unlockAccount(personal.defaultAccount, "abcd1234", 1000000, function (error, result) {
    console.log("Unlocked : " + result)
});

class RawContract {
    constructor(file) {
        this.file = file;
        this.compiled = this.load_file();
        this.contract = {};
        this.CONTRACT = new web3.eth.Contract(this.abi);
    }

    get abi() {
        return this.compiled.abi;
    }

    get bytecode() {
        return this.compiled.bytecode;
    }

    load_file() {
        let fs = require('fs');
        return JSON.parse(fs.readFileSync(this.file, 'utf8'));
    }

    estimate_gas(args, gasPrice) {
        let ret = 0;
        // console.log(this.CONTRACT);
        this.CONTRACT.deploy({
            data: this.bytecode,
            arguments: args
        }).estimateGas({}).then(function (gasAmount) {
            console.log("Estimated gas amount : " + gasAmount);
            ret = gasAmount;
            console.log("ret = " + ret * gasPrice);
            return ret;
        }).catch(function (error) {
            console.log("Error : " + error);
        });
    }

    deploy(args) {
        let _gasAmount;
        _this = this;
        this.contract = this.CONTRACT.deploy({
            data: this.abi,
            arguments: args
        }).estimateGas({}).then(function (gasAmount) {
            _gasAmount = gasAmount;
            _this.CONTRACT.send({
                from: personal.defaultAccount,
                gas: _gasAmount,
                gasPrice: web3.utils.toWei('1', 'gwei')
            }, function (error, transactionHash) {
                console.log("Transaction Hash : " + transactionHash);
            }).on('error', function (error) {
                console.log(error);
            }).on('transactionHash', function (transactionHash) {
                console.log("Transaction Hash : " + transactionHash);
            }).on('receipt', function (receipt) {
                console.log("Receipt : ", receipt.contractAddress); // contains the new contract address
            }).on('confirmation', function (confirmationNumber, receipt) {
                console.log("Confirmation : " + confirmationNumber);
                console.log("Receipt : " + receipt);
            }).then(function (newContractInstance) {
                console.log(newContractInstance.options.address) // instance with the new contract address
            });
        });
    }
}

let admin = new RawContract("../build/contracts/Admin.json");
// console.log(admin.deploy([]));
admin.estimate_gas([], web3.utils.toWei('1', 'gwei'));


// let gasEstimate = web3.eth.estimateGas({data: bytecode});
// let MyContract = web3.eth.contract(JSON.parse(abi));
//
// var myContractReturned = MyContract.new(param1, param2, {
//     from:mySenderAddress,
//     data:bytecode,
//     gas:gasEstimate}, function(err, myContract){
//     if(!err) {
//         // NOTE: The callback will fire twice!
//         // Once the contract has the transactionHash property set and once its deployed on an address.
//
//         // e.g. check tx hash on the first call (transaction send)
//         if(!myContract.address) {
//             console.log(myContract.transactionHash) // The hash of the transaction, which deploys the contract
//
//             // check address on the second call (contract deployed)
//         } else {
//             console.log(myContract.address) // the contract address
//         }
//
//         // Note that the returned "myContractReturned" === "myContract",
//         // so the returned "myContractReturned" object will also get the address set.
//     }
// });
//
// // Deploy contract syncronous: The address will be added as soon as the contract is mined.
// // Additionally you can watch the transaction by using the "transactionHash" property
// var myContractInstance = MyContract.new(param1, param2, {data: myContractCode, gas: 300000, from: mySenderAddress});
// myContractInstance.transactionHash // The hash of the transaction, which created the contract
// myContractInstance.address // undefined at start, but will be auto-filled later