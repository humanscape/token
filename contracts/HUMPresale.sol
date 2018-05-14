pragma solidity ^0.4.23;

import "./crowdsale/WhitelistedCrowdsale.sol";
import "./crowdsale/CappedCrowdsale.sol";
import "./crowdsale/MintedCrowdsale.sol";
import "./crowdsale/IndividuallyCappedCrowdsale.sol";
import "./HUMToken.sol";


contract HUMPresale is WhitelistedCrowdsale, CappedCrowdsale, IndividuallyCappedCrowdsale {
  uint256 public startNumber;
  uint256 public endNumber;
  uint256 public constant minimum = 100000000000000000; // 0.1 ether

  constructor (
    uint256 _startNumber,
    uint256 _endNumber,
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
    startNumber = _startNumber;
    endNumber = _endNumber;
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
    super._preValidatePurchase(_beneficiary, _weiAmount);

    bool isOverMinimum = _weiAmount >= minimum;
    bool isOnSale = block.number >= startNumber && block.number <= endNumber;

    require(isOverMinimum && isOnSale);
  }

}
