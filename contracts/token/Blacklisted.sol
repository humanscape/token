pragma solidity ^0.4.23;

import "../ownership/MultiOwnable.sol";

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract Blacklisted {

  mapping(address => bool) public blacklist;

  /**
  * @dev Throws if called by any account other than the owner.
  */
  modifier notBlacklisted() {
    require(blacklist[_villain] == false);
    _;
  }

  /**
   * @dev Adds single address to blacklist.
   * @param _villain Address to be added to the blacklist
   */
  function addToBlacklist(address _villain) external onlyOwner {
    blacklist[_villain] = true;
  }

  /**
   * @dev Adds list of addresses to blacklist. Not overloaded due to limitations with truffle testing.
   * @param _beneficiaries Addresses to be added to the blacklist
   */
  function addManyToBlacklist(address[] _beneficiaries) external onlyOwner {
    for (uint256 i = 0; i < _beneficiaries.length; i++) {
      blacklist[_beneficiaries[i]] = true;
    }
  }

  /**
   * @dev Removes single address from blacklist.
   * @param _villain Address to be removed to the blacklist
   */
  function removeFromBlacklist(address _villain) external onlyOwner {
    blacklist[_villain] = false;
  }
}
