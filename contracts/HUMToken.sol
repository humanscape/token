pragma solidity ^0.4.23;

import "./token/MintableToken.sol";
import "./token/BurnableToken.sol";


/**
 * @title HUMToken
 * @dev ERC20 HUMToken.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract HUMToken is MintableToken, BurnableToken {

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
    emit Transfer(0x0, _wallet, INITIAL_SUPPLY);
  }

  modifier onlyTransferable() {
    require(isUnlocked
      || hasRole(msg.sender, ROLE_ADMIN)
      || hasRole(msg.sender, ROLE_ADVISOR));
    _;
  }

  function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable returns (bool) {
      return super.transferFrom(_from, _to, _value);
  }

  function transfer(address _to, uint256 _value) public onlyTransferable returns (bool) {
      return super.transfer(_to, _value);
  }
  
  function unlockTransfer() public onlyAdmin {
      isUnlocked = true;
  }

}
