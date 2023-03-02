// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

import "./LiquidityPool.sol";

contract MotherContract {
  mapping (address=>address[]) public ownedPools;
  mapping (address=>uint) public poolToId;
  address[] public pools;
  address public lpTemplate;
  address public lpTokenTemplate;
  address public lpErc1155Template;

  event PoolCreated(address _addr,uint256 amount);
  constructor(address _lpTemplate, address _lpTokenTemplate, address _lpErc1155Template){
    lpTemplate = _lpTemplate;
    lpTokenTemplate = _lpTokenTemplate;
    lpErc1155Template = _lpErc1155Template;
  }
  /**
   *  Will create a pool with the Native Currency as base currency.
   * @param amount The amount of ETH to initialize the pool.
   * @param name The name of the pool.
   * @param _performanceFees The fees paid for performances to pool owner.
   * @param _maintenanceFees The fees paid to Khonsu Maintainers.
   */

  function createPoolETH(uint256 amount, string memory name, uint256 _performanceFees, uint256 _maintenanceFees) external payable {
    LiquidityPool pool;
    //require(amount>=1000000000000000);
    pool=LiquidityPool(Clones.clone(lpTemplate));
    pool.init{value:msg.value}(msg.sender,name,address(0x0),lpTokenTemplate, lpErc1155Template, _performanceFees, _maintenanceFees);
    emit PoolCreated(address(pool),msg.value);
    poolToId[address(pool)] = pools.length;
    pools.push(address(pool));
    ownedPools[msg.sender].push(address(pool));
  }

  /**
   *  Will create a pool with an ERC20 token as base currency.
   * @param amount The amount of ERC20 to initialize the pool.
   * @param name The name of the pool.
   * @param _performanceFees The fees paid for performances to pool owner.
   * @param _maintenanceFees The fees paid to Khonsu Maintainers.
   */
  function createPool(uint256 amount, string memory name, address base, uint256 _performanceFees, uint256 _maintenanceFees) external {
    LiquidityPool pool;
    IERC20 erc20Token;//ERC20 instance of base token. Required to send funds to LP.
    //require(amount>=1000000000000000);
    pool=LiquidityPool(Clones.clone(lpTemplate));
    erc20Token = IERC20(base);
    require(erc20Token.allowance(msg.sender, address(this)) >= amount, "KHONSU: Insufficient allowance");
    erc20Token.transferFrom(msg.sender, address(pool), amount);
    pool.init(msg.sender,amount,name,base,lpTokenTemplate, lpErc1155Template, _performanceFees, _maintenanceFees);
    emit PoolCreated(address(this),amount);
    poolToId[address(pool)] = pools.length;
    pools.push(address(pool));
    ownedPools[msg.sender].push(address(pool));
  }
  /**
   * Will return which pools does the user own.
   * @param user The user to lookup to find which pools own.
   * @return users All pools created by an user.
   */
  function getUserPools(address user) external view returns (address[] memory){
    return ownedPools[user];
  }
  /**
   * @return pools Will return all the pools.
   * 
   */
  function getPools() external view returns(address[] memory){
      return pools;
  }
}

