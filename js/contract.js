class Contract {

    constructor(web3, name, address, abi_url) {
        this.web3 = web3;
        this.name = name;
        this.contract = {};
        this.instance = {};
        if (typeof address !== 'undefined') {
            this.address = address;
        }
        if (typeof abi_url !== "undefined") {
            this.abi_url = abi_url;
        }
    }

    prepare_contract() {
        let _this = this;
        return new Promise(function (resolve, reject) {
            if (typeof _this.address === "undefined" || typeof _this.abi_url === "undefined") {
                console.log("Invalid address or abi file path");
                return;
            }
            $.getJSON(_this.abi_url, function (data) {
                _this.contract = _this.web3.eth.contract(data["abi"]);
                _this.instance = _this.contract.at(_this.address);
                console.log(_this.name + " contract @ " + _this.address + " has been loaded");
            }).done(function () {
                resolve();
            }).fail(function () {
                reject();
            })
        });

    }
}