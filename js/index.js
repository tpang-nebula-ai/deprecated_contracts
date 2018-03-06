// let web3 = new Web3(new Web3.providers.HttpProvider("http://192.168.88.151:8545"));

window.onload = function () {

    var browserChrome = !!window.chrome && !!window.chrome.webstore;
    var browserFirefox = typeof InstallTrigger !== 'undefined';

    if (!browserChrome && !browserFirefox) {
        window.location.href = "./notice/notice_supported/index.html";
    } else if (typeof web3 === 'undefined') {
        window.location.href = "./notice/notice_install/index.html";
        console.log('No web3? You should consider trying MetaMask!')
    } else {
        web3 = new Web3(web3.currentProvider);

        if (web3.eth.defaultAccount === undefined) {
            window.location.href = "./notice/notice_locked/index.html"
            // alert("Please log into your MetaMask account using MetaMask Plugin");
            // Currently only support Chrome with MetaMask plugin installed
            //loginWallet using private key or JSON format
            //
            // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
            // web3 = new Web3(new Web3.providers.HttpProvider("http://18.221.71.211:8545"));
        } else {
            //all good: start app
            start_app();
        }
    }
};
let admin_address = "0x2f1400233d6368fe3f38767a5c52775d423132fd";

function start_app() {
    const nebula = new Nebula(web3, admin_address);

    nebula.initialize()
        .then(function () {
            // nebula.current_task["app_id"]= 1;
            nebula.current_task["name"] = "name new 2";
            nebula.current_task["script"] = "script 2";
            nebula.current_task["data"] = "data 1";
            nebula.current_task["output"] = "output 1";
            nebula.current_task["params"] = "parameters 1";
            nebula.current_task["fee"] = web3.toWei(5, "ether");
            return nebula.create_task();
        })
        .then((result) => {
            console.log("Current task address : ", result);
            return nebula.get_task_status();
        })
        .then(result => {
            console.log("Task status : ");
            console.log(result);
            return nebula.get_task_info();
        })
        .then(result => {
            console.log("Task Info : ");
            console.log(result);
            return nebula.get_task_history();
        })
        .then(result => {
            console.log("History : ");
            console.log(result);
            return nebula.get_client_info();
        })
        .then(result => {
            console.log("Client info : ");
            console.log(result);
            return nebula.submissible();
        })
        .then(result => {
            console.log("Submissible");
            console.log(result);
            return nebula.get_task_position();
        })
        .then(result => {
            console.log("task position : ");
            console.log(result);
            console.log("wait for dispatch");
            return nebula.wait_for_dispatch();
            // return nebula.cancel_task();
        })
        .then(() => {
            console.log("wait for start");
            return nebula.wait_for_start();
        })
        .then(() => {
            console.log("wait for complete");
            return nebula.wait_for_complete();
        })
        .catch(console.log);
}
