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
    window.nebula = new Nebula(web3, admin_address);

    nebula.initialize()
        .then(() => {
            nebula.task_queue_size_updater(result => {
                console.log("Current task queue size is ", result);
            });
            nebula.ai_queue_size_updater(result => {
                console.log("Current AI queue size is ", result);
            });
            nebula.submissible_updater(result => {
                console.log("Client is", result ? "" : "not", "eligible to submit a new task");
            });

            return nebula.submissible();
        })
        .then((is_submissible) => {
            if (is_submissible) {
                //load default app. todo temp testing
                submit_task();
            } else {
                //load current task. todo temp testing
                resume_task();
            }
        });
}

function submit_task() {
    nebula.get_client_info()
        .then(result => {
            console.log("Client Info");
            console.log("Banned : ", result[0]);
            console.log("User level : ", Number(result[2]));
            return nebula.submissible();
        })
        .then((is_submissible) => {
            if (is_submissible) {
                // nebula.current_task["app_id"]= 1;
                nebula.current_task["name"] = "name new 2";
                nebula.current_task["script"] = "script 2";
                nebula.current_task["data"] = "data 1";
                nebula.current_task["output"] = "output 1";
                nebula.current_task["params"] = "parameters 1";
                nebula.current_task["fee"] = web3.toWei(5, "ether");
                return nebula.create_task();
            } else {
                //todo
                throw "Client is not submissible";
            }
        })
        .then((result) => {
            console.log("Current task address : ", result);
            return nebula.get_task_info();
        })
        .then(result => {
            console.log("Task Info");
            console.log("App ID: ", Number(result[0]));
            console.log("Task Name:", result[1]);
            console.log("Script Address: ", result[2]);
            console.log("Data Address: ", result[3]);
            console.log("Output Address: ", result[4]);
            console.log("Parameters: ", result[5]);
            return nebula.get_task_history();
        })
        .then(result => {
            console.log("History (last 15): ");
            let end = result.length > 15 ? result.length - 15 : 0;
            for (let i = result.length - 1; i >= end; --i) {
                console.log(i, " : ", result[i]);
            }
            return nebula.get_task_position();
        })
        .then(result => {
            console.log("task position : ", Number(result));
            console.log("waiting for dispatch");
            return nebula.wait_for_dispatch();
        })
        .then(() => {
            console.log("waiting for start");
            return nebula.wait_for_start();
        })
        .then(() => {
            console.log("waiting for complete");
            return nebula.wait_for_complete();
        })
        .catch(console.log);


}

function resume_task() {
    nebula.get_active_task()
        .then(result => {
            result.forEach((item, index) => {
                nebula.current_task_position_updater(item, position => {
                    console.log("current position for task ", result[index], " : ", position);
                });
            });
            if (result.length > 0) {
                let display_task = result[result.length - 1];
                nebula.current_task["address"] = display_task;
                return nebula.get_task_status(display_task)
                    .then(status => {
                        if (status["create_time"] === 0) {
                            throw "Create time is empty, task address is incorrect";
                        } else {
                            console.log("waiting for dispatch");
                            return nebula.wait_for_dispatch(display_task);
                        }
                    })
                    .then(() => {
                        console.log("waiting for start");
                        return nebula.wait_for_start(display_task);
                    })
                    .then(() => {
                        console.log("waiting for complete");
                        return nebula.wait_for_complete(display_task);
                    })
                    .catch(console.log);
            } else {
                console.log("no active task")
            }
        })
        .catch(console.log);
}
