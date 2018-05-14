pragma solidity ^0.4.23;

import "./crowdsale/WhitelistedCrowdsale.sol";
import "./crowdsale/CappedCrowdsale.sol";
import "./crowdsale/IndividuallyCappedCrowdsale.sol";
import "./HUMToken.sol";


contract HUMPresale is WhitelistedCrowdsale, CappedCrowdsale, IndividuallyCappedCrowdsale {

  uint256 public constant minimum = 100000000000000000; // 0.1 ether
  bool public isOnSale = false;

  constructor (
    uint256 _rate,
    address _wallet,
    HUMToken _token,
    uint256 _cap
  ) 
    public
    Crowdsale(_rate, _wallet, _token)
    CappedCrowdsale(_cap)
    IndividuallyCappedCrowdsale(100 * (10 ** 18))  // 100 ether
  { 
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
    super._preValidatePurchase(_beneficiary, _weiAmount);

    bool isOverMinimum = _weiAmount >= minimum;
  
    require(isOverMinimum && isOnSale);
  }

  function startSale() public onlyAdminOrAdvisor {
    require(!isOnSale);

    isOnSale = true;
  }

  function endSale() public onlyAdminOrAdvisor {
    require(isOnSale);

    withdrawToken();

    isOnSale = false;
  }

  function withdrawToken() public onlyAdminOrAdvisor {
    token.transfer(wallet, token.balanceOf(this));
    emit Withdraw(wallet, token.balanceOf(this));
  }

  event Withdraw(address indexed _from, uint256 _amount);
}
