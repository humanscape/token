var HUMToken = artifacts.require("../contracts/HUMToken.sol");
var HUMPresale = artifacts.require("../contracts/HUMPresale.sol");

contract('HUMToken and HUMPresale', function(accounts) {
    it("get totalSupply", function() {
        return HUMToken.deployed().then(function(instance) {
            return instance.totalSupply();
        })
        .then(function(value) {
            console.log(value.toNumber());
        });
    });
    it("balanceOf 0", function() {
        return HUMToken.deployed().then(function(instance) {
            return instance.balanceOf(web3.eth.accounts[0]);
        })
        .then(function(value) {
            console.log(value.toNumber());
        });
    });
    it("transfer to 1", function() {
        return HUMToken.deployed().then(function(instance) {
            assert(instance.transfer(web3.eth.accounts[1], web3.toWei("2", "ether")));
        });
    });
    it("balanceOf 1", function() {
        return HUMToken.deployed().then(function(instance) {
            return instance.balanceOf(web3.eth.accounts[1]);
        })
        .then(function(value) {
            console.log(value.toNumber());
        });
    });
    it("balanceOf 0", function() {
        return HUMToken.deployed().then(function(instance) {
            return instance.balanceOf(web3.eth.accounts[0]);
        })
        .then(function(value) {
            console.log(value.toNumber());
        });
    });
    it("addToWhitelist 1", function() {
        return HUMPresale.deployed().then(function(instance) {
            return instance.addToWhitelist(web3.eth.accounts[1]);
        })
        .then(function(value) {
            console.log(value);
        });
    });
});