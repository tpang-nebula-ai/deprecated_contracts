const admin_abi_json = "../contract/abi/getter/admin_interface.json";
const client_abi_json = "../contract/abi/submitter/ClientInterfaceSubmitter.json";
const dispatcher_abi_json = "../contract/abi/submitter/DispatcherInterfaceSubmitter.json";
const distributor_abi_json = "../contract/abi/submitter/DistributorInterfaceSubmitter.json";
const queue_task_abi_json = "";
const queue_ai_abi_json = "";
const taskpool_abi_json = "../contract/abi/getter/TaskPoolInterfaceGetter.json";
const account_abi_json = "../contract/abi/getter/AccountInterfaceGetters.json";


class Nebula {

    constructor(web3, admin_address) {
        this.admin_address = admin_address;
        this.web3 = web3;
    }

    contracts() {
        this.client = {};
        this.distributor = {};
        this.dispatcher = {};
        this.queue_ai = {};
        this.queue_task = {};
        this.account = {};
        this.taskpool = {};
        this.admin = {};
    }

    task() {
        this.current_task = {
            app_id: 0,
            name: "",
            script: "",
            data: "",
            output: "",
            params: "",
            create_hash: "",
            dispatch_time: 0,
            start_time: 0,
            finish_time: 0,
            error_time: 0,

        };
        this.task_history = [];
        this.active_tasks = [];
        this.job_history = [];
        this.active_job = "";
    }


    initialize() {
        let _this = this;
        return this.load_admin()
            .then(function () {
                return _this.admin_get_client();
            }).then(function () {
                return _this.admin_get_dispatcher();
            }).then(function () {
                return _this.admin_get_distributor();
            }).then(function () {
                return _this.admin_get_account();
            }).then(function () {
                return _this.admin_get_taskpool();
            }).catch(console.log);
        // .then(function () {
        //     return _this.admin_get_queue_ai_address();
        // }).then(function () {
        //     return _this.admin_get_queue_task_address();
        // })

    }

    load_admin() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin = new Contract(_this.web3, "Admin", _this.admin_address, admin_abi_json);
            console.log(_this.admin);
            _this.admin.prepare_contract().then(resolve).catch(reject);
        });
    }

    admin_get_client() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin.instance.client_address(function (error, result) {
                if (error) reject(error);
                else {
                    _this.client = new Contract(_this.web3, "Client", result, client_abi_json);
                    _this.client.prepare_contract().then(resolve).catch(reject);
                }
            });
        });
    }

    admin_get_dispatcher() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin.instance.dispatcher_address(function (error, result) {
                if (error) reject(error);
                else {
                    _this.dispatcher = new Contract(_this.web3, "Dispatcher", result, dispatcher_abi_json);
                    _this.dispatcher.prepare_contract().then(resolve).catch(reject);
                }
            });
        });
    }

    admin_get_distributor() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin.instance.distributor_address(function (error, result) {
                if (error) reject(error);
                else {
                    _this.distributor = new Contract(_this.web3, "Distributor", result, distributor_abi_json);
                    _this.distributor.prepare_contract().then(resolve).catch(reject);
                }
            });
        });
    }

    admin_get_account() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin.instance.account_address(function (error, result) {
                if (error) reject(error);
                else {
                    _this.account = new Contract(_this.web3, "Account", result, account_abi_json);
                    _this.account.prepare_contract().then(resolve).catch(reject);
                }
            });
        });
    }

    admin_get_taskpool() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin.instance.taskpool_address(function (error, result) {
                if (error) reject(error);
                else {
                    _this.taskpool = new Contract(_this.web3, "Taskpool", result, taskpool_abi_json);
                    _this.taskpool.prepare_contract().then(resolve).catch(reject);
                }
            });
        });
    }

    admin_get_queue_ai_address() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin.instance.queue_ai_address(function (error, result) {
                if (error) reject(error);
                else {
                    _this.queue_ai = new Contract(_this.web3, "Ai Queue", result, queue_ai_abi_json);
                    _this.queue_ai.prepare_contract().then(resolve).catch(reject);
                }
            });
        });
    }

    admin_get_queue_task_address() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            _this.admin.instance.queue_task_address(function (error, result) {
                if (error) reject(error);
                else {
                    _this.queue_task = new Contract(_this.web3, "Task Queue", result, queue_task_abi_json);
                    _this.queue_task.prepare_contract().then(resolve).catch(reject);
                }
            });
        });
    }

    /*
     * Client functions
     */
    create_account(passphrase) {

    }

    import_key(private_key) {

    }

    /*
     * Task related
     */
    /**
     * Create a task
     * @param app_id
     * @param name
     * @param script
     * @param data
     * @param output
     * @param param
     */
    create_task() {
        _this = this;
        return new Promise(function (resolve, reject) {
            _this.distributor.create_task(
                _this.current_task["app_id"],
                _this.current_task["name"],
                _this.current_task["script"],
                _this.current_task["data"],
                _this.current_task["output"],
                _this.current_task["param"],
                function (error, result) {
                    if (error) reject(error);
                    else {
                        console.log("Create task txHash : ", result);
                        return resolve(result);
                    }
                })
        });
    }

    wait_for_dispatch(task) {

    }

    cancel_task(task_id) {
        //distributor#cancel_task
    }

    reassignable(task_address) {
        //taskpool#reassignable
    }

    reassign_task(task) {
        //distributor#reassign_task_request
    }

    get_task_status(task) {
        //taskpool#get_status
    }

    get_task_info(task) {
        //taskpool#get_task
    }

    get_task_history(app_id) {
        //account#task_history
    }

    get_active_task(app_id) {
        //account#active_tasks
    }

    get_client_info(client) {
        //CIS#get_client_c
    }

    submissible(client, app_id) {
        //CIS#submissible
    }

    get_task_position(task) {
        //Dispatcher#task_position
    }

    get_task_queue_size() {
        //todo interface not made
    }

    get_ai_queue_size_c() {
        //todo interface not made
    }

    pay_completion_fee() {
        //distributor#pay_completion_fee
    }


    /*
    Miner info pages
     */
    get_miner_info(worker) {
        //CIM#get_client_m
    }

    get_ai_position(worker) {
        //dispatcherInterfaceMiner#ai_position
    }

    get_ai_queue_size_m() {
        //dispatcherInterfaceMiner#ai_queue_length
    }

    get_active_job(task) {
        //account#active_job
    }

    get_job_history(task) {
        //account#job_history
    }

    get_credits(worker) {
        //account#get_credits
    }

    get_penalty() {
        //CIM#get_penalty
    }

    get_minimal_credit() {
        //CIM#get_minimal_credit
    }

    apply_eligibility(worker) {
        //CIM#apply_eligibility
    }

    withdraw_credits(worker, amount) {
        //CIM#withdrawal
    }


}

let web3 = new Web3(new Web3.providers.HttpProvider("http://192.168.88.151:8545"));
const nebula = new Nebula(web3, "0xba25f80076050187db9ccee8854bd3dfd94c661c");
nebula.initialize().then(function () {
    console.log(nebula.client.address);
    console.log(nebula.dispatcher.address);
    console.log(nebula.distributor.address);
    console.log(nebula.account.address);
    console.log(nebula.taskpool.address);
    // console.log(this.queue_ai.address);
    // console.log(this.queue_task.address);
}).catch(console.log);