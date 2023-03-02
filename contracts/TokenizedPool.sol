// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "./extensions/Mintable.sol";
import "./LiquidityPool.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract TokenizedPool is Initializable, Mintable, ERC20Upgradeable {

    address public liquidityPool;
    address public ROUTER;

    event TotalCalculated(uint256 total);

    function init(string memory symbol,address pool) public initializer {
        liquidityPool = pool;
        __ERC20_init(LiquidityPool(pool).name(),symbol);
        __Mintable_init(msg.sender);
        ROUTER = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
        //MATIC: 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
        //ETH: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    }

  /*function getTokenProfit(address user,address token) public view returns (int256) {
      int256 profit=0;
      uint256 price;
      address[] memory path=new address[](2);
      IUniswapV2Router02 router=IUniswapV2Router02(ROUTER);
      uint256 totalBalance=LiquidityPool(liquidityPool).getTotalBalance();
      uint256 tokenBalance;
      if (token!=address(0x0)) path[0]=token;
      else path[0]=router.WETH();
      path[1]=LiquidityPool(liquidityPool).base();
      tokenBalance=getUserTokenBalance(user,token);
      if (tokenBalance!=0) {
        profit+=(int256(router.getAmountsOut(tokenBalance,path)[1]))-int256(balanceOf(user)*(LiquidityPool(liquidityPool).tokenInvestedAmount(token)*1000000000000000000/LiquidityPool(liquidityPool).investedAmount())/1000000000000000000);
      }
      return profit;
  }
  function getUserTokenBalance(address user, address token) public view returns (uint256) {
        IUniswapV2Router02 router=IUniswapV2Router02(ROUTER);
        address[] memory path=new address[](2);
        if(token==address(0x0)) path[0]=router.WETH();
        else path[0]=token;
        path[1]=LiquidityPool(liquidityPool).base();
        if(IERC20(token).balanceOf(liquidityPool)==0) return 0;
        return IERC20(token).balanceOf(address(this))*(balanceOf(user)*1000000000000000000/LiquidityPool(liquidityPool).investedAmount())/1000000000000000000;
  }*/
  function estimateWithdraw(address token,  uint256 amount) external view returns (uint256) {
    IUniswapV2Router02 router=IUniswapV2Router02(ROUTER);
    LiquidityPool lp = LiquidityPool(liquidityPool);
    address base = lp.base();
    address[] memory path = new address[](2);
    uint256 totalAmount;
    uint256 sharesAmount;
    uint256 outTokenAmount;
    uint256 ownerShares;
    bool isShare;
    uint i;
    address baseFixed = base;
    if(base==address(0x0)) {
      baseFixed = router.WETH();
    }

    for (i = 0; i < lp.tokensLength(); i++) {
      if (lp.tokens(i) == token) isShare = true;
        if(lp.tokens(i) == base){
          if (lp.tokens(i) == address(0x0)) {
            totalAmount += liquidityPool.balance;
          }
          else {
            totalAmount += IERC20(lp.tokens(i)).balanceOf(liquidityPool);
          }
      }
      else {
        if (lp.tokens(i) == address(0x0) && liquidityPool.balance > 0) {
          path[0] = router.WETH();
          path[1] = baseFixed;
          totalAmount += router.getAmountsOut(liquidityPool.balance, path)[1];
        }
        else if (IERC20(lp.tokens(i)).balanceOf(liquidityPool) > 0){
          path[0] = lp.tokens(i);
          path[1] = baseFixed;
          totalAmount += router.getAmountsOut(IERC20(lp.tokens(i)).balanceOf(liquidityPool), path)[1];
        }
      }
      if(isShare) {
        if (lp.tokens(i) == address(0x0) && liquidityPool.balance > 0) {
          sharesAmount = liquidityPool.balance;
        }
        else if(IERC20(lp.tokens(i)).balanceOf(liquidityPool) > 0){
          sharesAmount = IERC20(lp.tokens(i)).balanceOf(liquidityPool);
        }
      }
      isShare = false;
    }
    //return totalAmount;
    ownerShares = amount * 1e18 / totalSupply();
    //return ownerShares;
    path[0] = baseFixed;
    if(token == address(0x0))
      path[1] = router.WETH();
    else path[1] = token;
    if(token == base) outTokenAmount = totalAmount * ownerShares / 1e18;
    else outTokenAmount = router.getAmountsOut(totalAmount * ownerShares / 1e18, path)[1];

    if(token == address(0x0)) {
      require(outTokenAmount <= liquidityPool.balance,"Insufficient ETH");
    }
    else {
      require(outTokenAmount <= IERC20(token).balanceOf(liquidityPool),"Insufficient token");
    }

    return outTokenAmount;
  }



  function mint(address user,uint256 amount) external onlyMinter {
      _mint(user,amount);
    }
}
