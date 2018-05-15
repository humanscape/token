pragma solidity ^0.4.23;

import "./crowdsale/WhitelistedCrowdsale.sol";
import "./crowdsale/CappedCrowdsale.sol";
import "./crowdsale/IndividuallyCappedCrowdsale.sol";
import "./HUMToken.sol";


contract HUMPresale is WhitelistedCrowdsale, CappedCrowdsale, IndividuallyCappedCrowdsale {
  
  uint256 public constant minimum = 100000000000000000; // 0.1 ether
  bool public isOnSale = false;

  mapping(address => uint256) public bonusTokens;
  uint256 public bonusPercent;
  address[] public contributors;

  event DistrubuteBonusTokens(address sender);
  event Withdraw(address indexed _from, uint256 _amount);

  constructor (
    uint256 _rate,
    uint256 _bonusPercent,
    address _wallet,
    HUMToken _token,
    uint256 _cap,
    uint256 _individualCapEther
  ) 
    public
    Crowdsale(_rate, _wallet, _token)
    CappedCrowdsale(_cap)
    IndividuallyCappedCrowdsale(_individualCapEther.mul(10 ** 18))
  { 
    bonusPercent = _bonusPercent;
  }

  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    super._processPurchase(_beneficiary, _tokenAmount);
    if (bonusPercent != 0) {
      if (bonusTokens[_beneficiary] == 0) {
        contributors.push(_beneficiary);
      }
      bonusTokens[_beneficiary] = bonusTokens[_beneficiary].add(_tokenAmount.mul(bonusPercent).div(100));
    }
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
    super._preValidatePurchase(_beneficiary, _weiAmount);

    bool isOverMinimum = _weiAmount >= minimum;
  
    require(isOverMinimum && isOnSale);
  }

  function openSale() public onlyAdminOrAdvisor {
    require(!isOnSale);

    isOnSale = true;
  }

  function closeSale() public onlyAdminOrAdvisor {
    require(isOnSale);

    withdrawToken();

    isOnSale = false;
  }

  function withdrawToken() public onlyAdminOrAdvisor {
    uint256 balanceOfThis = token.balanceOf(this);
    token.transfer(wallet, balanceOfThis);
    emit Withdraw(wallet, balanceOfThis);
  }

  function distributeBonusTokens() public onlyAdminOrAdvisor {
    require(!isOnSale);

    for (uint i = 0; i < contributors.length; i++) {
      if (bonusTokens[contributors[i]] > 0) {
        HUMToken(token).mint(contributors[i], bonusTokens[contributors[i]]);
        bonusTokens[contributors[i]] = 0;
      }
    }

    emit DistrubuteBonusTokens(msg.sender);
  }

}
