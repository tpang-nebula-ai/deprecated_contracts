module.exports = {
    networks: {
        testnet: {
            host: "18.221.71.211",
            port: 8545,
            network_id: 666
        },
        helix: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*",
            gas: 4712387,
        },
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: 5777,
            gas: 4712387
        }
    }
};
