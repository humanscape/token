pragma solidity ^0.4.23;

import "./token/MintableToken.sol";
import "./token/BurnableToken.sol";
import "./token/Blacklisted.sol";
import "./introspection/ERC165.sol";

/**
 * @title HUMToken
 * @dev ERC20 HUMToken.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract HUMToken is MintableToken, BurnableToken, Blacklisted, ERC165 {

  string public constant name = "HUMToken"; // solium-disable-line uppercase
  string public constant symbol = "HUM"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it

  uint256 public constant INITIAL_SUPPLY = 2500 * 1000 * 1000 * (10 ** uint256(decimals)); // 2,500,000,000 HUM

  bool public isUnlocked = false;
  
  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  constructor(address _wallet) public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[_wallet] = INITIAL_SUPPLY;
    emit Transfer(address(0), _wallet, INITIAL_SUPPLY);

    // ERC165. register ERC20 Interface
    _registerInterface(
        bytes4(keccak256('totalSupply()'))
        ^ bytes4(keccak256('balanceOf(address)'))
        ^ bytes4(keccak256('transfer(address,uint256)'))
        ^ bytes4(keccak256('allowance(address,address)'))
        ^ bytes4(keccak256('transferFrom(address,address,uint256)'))
        ^ bytes4(keccak256('approve(address,uint256)'))
    );
  }

  modifier onlyTransferable() {
    require(isUnlocked || owners[msg.sender] != 0);
    _;
  }

  function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
      return super.transferFrom(_from, _to, _value);
  }

  function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
      return super.transfer(_to, _value);
  }
  
  function unlockTransfer() public onlyOwner {
      isUnlocked = true;
  }
  
  function lockTransfer() public onlyOwner {
      isUnlocked = false;
  }

}
