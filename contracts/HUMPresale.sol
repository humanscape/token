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

  event DistrubuteBonusTokens(address indexed sender);
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

  function modifyTokenPrice(uint256 _rate) public onlyAdminOrAdvisor {
    rate = _rate;
  }

  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    super._processPurchase(_beneficiary, _tokenAmount);

    if (bonusPercent > 0) {
      if (contributions[_beneficiary] == 0) {
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

    if (token.balanceOf(this) > 0) {
      withdrawToken();
    }

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
        token.transferFrom(wallet, contributors[i], bonusTokens[contributors[i]]);
        bonusTokens[contributors[i]] = 0;
      }
    }

    emit DistrubuteBonusTokens(msg.sender);
  }

  function getContributors() public view onlyAdminOrAdvisor returns(address[]) {
    return contributors;
  }

  /// @dev get addresses who has bonus tokens
  /// @return Returns array of addresses.
  function getBonusList() public view onlyAdminOrAdvisor returns(address[]) {
    address[] memory contributorsTmp = new address[](contributors.length);
    uint count = 0;
    uint i;

    for (i = 0; i < contributors.length; i++) {
      if (bonusTokens[contributors[i]] > 0) {
        contributorsTmp[count] = contributors[i];
        count += 1;
      }
    }
    
    address[] memory _bonusList = new address[](count);
    for (i = 0; i < count; i++) {
      _bonusList[i] = contributorsTmp[i];
    }

    return _bonusList;
  }

  /// @dev distribute bonus tokens to addresses who has bonus tokens
  /// @param _bonusList array of addresses who has bonus tokens.
  function distributeBonusTokensByList(address[] _bonusList) public onlyAdminOrAdvisor {
    require(!isOnSale);

    for (uint i = 0; i < _bonusList.length; i++) {
      if (bonusTokens[_bonusList[i]] > 0) {
        token.transferFrom(wallet, _bonusList[i], bonusTokens[_bonusList[i]]);
        bonusTokens[_bonusList[i]] = 0;
      }
    }

    emit DistrubuteBonusTokens(msg.sender);
  }

}
