module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' // Match any network id
    },
    ropsten:  {
      host: "localhost",
      port:  8545,
      network_id: '*'
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      //from: "0x6801D5cf90DC6C412df1C05861bED344D8131692", // default address to use for any transaction Truffle makes during migrations
      network_id: '*',
      //gas: 4612388 // Gas limit used for deploys
    }
  }
};
