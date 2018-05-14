const HUMPresale = artifacts.require('../contracts/examples/HUMPresale.sol');
const HUMToken = artifacts.require('../contracts/examples/HUMToken.sol');

module.exports = function(deployer) {
    const openingTime = web3.eth.getBlock('latest').timestamp + 100; // two secs in the future
    const closingTime = openingTime + 86400 * 200; // 200 days
    const rate = new web3.BigNumber(10);
    const cap = new web3.BigNumber(25 * 10000 * 10000);
    const wallet = web3.eth.coinbase;

    deployer
    .then(() => {
        return deployer.deploy(HUMToken);
    })
    .then(() => {
        return deployer.deploy(
            HUMPresale,
            //openingTime,
            //closingTime,
            rate,
            wallet,
            cap,
            HUMToken.address
        );
    });
};