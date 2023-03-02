// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    
    function balanceOf(address account) external view returns (uint256);

    
    function transfer(address recipient, uint256 amount) external returns (bool);

    
    function allowance(address owner, address spender) external view returns (uint256);

    
    function approve(address spender, uint256 amount) external returns (bool);

    
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    
    event Transfer(address indexed from, address indexed to, uint256 value);

    
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Pool is ChainlinkClient {
  using Chainlink for Chainlink.Request;

  address private oracle;
  bytes32 private jobId;
  uint256 private fee;
  bool public isClosed;
  

  address[] public users;
  address public owner;
  address public WBNB=0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;//0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd\\\\0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
  address public BUSD=0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7;//0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7\\\\0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56
  address public PSWAP=0xD99D1c33F9fC3444f8101754aBC46c52416550D1;//0xD99D1c33F9fC3444f8101754aBC46c52416550D1\\\\0x10ED43C718714eb63d5aA57B78B54704E256024E
  address public DEV;
  address public LINK=0x404460C6A5EdE2D891e8297795264fDe62ADBB75;

  address[] public tokens;
  mapping (address => uint256) public tokenInvestedAmount;
  mapping (address => bool) public userExist;
  mapping (address => uint256) public deposits;
  mapping (address => uint256) public tokenBalances;
  mapping (address => address) public referrers;
  mapping(bytes32=>address) tokensVerified;
  mapping (address => bool) public tokensValid;
  uint256 public investedBalance;
  bool public isInit;
  string public name;
  
  event Deposited(address sender,uint256 amount);
  event Received(address sender, uint amount);
  event Swapped(uint256 amount);
  event WithdrawnProfit(int256 profit);
  event QuoteCalced(uint256 amount);
  constructor(address _owner,string memory _name,address _dev){
    DEV=_dev;
    tokensValid[address(0x0)]=true;
    tokensValid[BUSD]=true;
    tokens.push(address(0x0));
    tokens.push(BUSD);
    name=_name;
    setChainlinkToken(LINK);
    oracle=0x23cA1B563a496d6E1Dfcefd25e2a676aAc0eEF4f;
    jobId="32c10d6e306e48ae97204a57538479e7";
    isInit=false;
    fee = 1 * 10 ** 18;
    owner=_owner;
  }
  receive() external payable {
    emit Received(msg.sender, msg.value);
  }
  function magnitude (uint x) public pure returns (uint) {
    require (x > 0);

    uint a = 0;
    uint b = 77;

    while (b > a) {
      uint m = a + b + 1 >> 1;
      if (x >= pow10 (m)) a = m;
      else b = m - 1;
    }

    return a;
  }

  function pow10 (uint x) private pure returns (uint) {
      uint result = 1;
      uint y = 10;
      while (x > 0) {
        if (x % 2 == 1) {
          result *= y;
          x -= 1;
        } else {
          y *= y;
          x >>= 1;
        }
      }
      return result;
  }
  function append(string memory a, string memory b, string memory c, string memory d, string memory e) internal pure returns (string memory) {

      return string(abi.encodePacked(a, b, c, d, e));

  }
    /**
     * Checks if a token is verified, so is in the PancakeSwap Extended list
     * @param token The token to be verified.
     */
    function getTokenVerified(address token) public view returns (bool) {
      return tokensValid[token];
    }
    /**
     * Checks if an address is present in the PancakeSwap Extended list.
     * @param addressToVerify The address to be verified if in PancakeSwap extended list.
     */
    function checkAddress(address addressToVerify) public onlyOwner 
    {   
        bytes32 reqid;
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        request.add("address",string(toAsciiString(addressToVerify)));
        reqid=sendChainlinkRequestTo(oracle, request,fee );
        tokensVerified[reqid]=addressToVerify;
    }
    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(42);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);            
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
    function fulfill(bytes32 _requestId, bool value) public recordChainlinkFulfillment(_requestId)
    {
        if (value) {
          tokensValid[tokensVerified[_requestId]]=true;
          tokens.push(tokensVerified[_requestId]);
        }
    }


  function transferOwnership (address _owner) public onlyOwner{
    owner=_owner;
  }
  /**
   * Returns the price of a given toekn
   * @param token The token to get the price.
   */
  function getPrice(address token) view public returns (uint256){
    if(token==BUSD) return 1000000000000000000;
    IPancakeRouter02 router=IPancakeRouter02(PSWAP);
    address[] memory path=new address[](2);
    path[1]=BUSD;
    if(token==address(0x0))
      path[0]=WBNB;
    else path[0]=token;
    return router.getAmountsOut(1000000000000000000,path)[1];
  }

  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }
  function init(uint256 amount) public{
    require(!isInit,"Pool already initialized");
    require(amount>=1000000000000000,"Minimum of 500 BUSD");

    isInit=true;
    IERC20 tokenInstance=IERC20(BUSD);
    tokenInstance.transferFrom(msg.sender, address(this), amount);
    deposits[owner]+=(amount);
    investedBalance+=amount;

    tokenBalances[BUSD]+=amount;

    tokenBalances[BUSD]=IERC20(BUSD).balanceOf(address(this));
    tokenInvestedAmount[BUSD]=tokenBalances[BUSD];
    users.push(owner);
    userExist[owner]=true;
  }
  /**
   * Adds a given amount to the user balance.
   * @param referrer The user who referred.
   * @param amount The amount to be credited.
   */
  function addFunds(address referrer,uint256 amount) public{
    require(!isClosed);
    //require((amount*getPrice(base)/1000000000000000000)>100000000000000000000);
    require(amount>=1000000000000000,"Minimum of 100 BUSD");
    uint i;
    uint256 tokenAmount;

    referrers[msg.sender]=referrer;

    IERC20 tokenInstance=IERC20(BUSD);
    tokenInstance.transferFrom(msg.sender, address(this), amount);

    deposits[msg.sender]+=(amount);
    investedBalance+=amount;

    tokenBalances[BUSD]+=amount;

    for(i=0;i<tokens.length;i++){
      if(tokens[i]!=BUSD&&tokenBalances[tokens[i]]!=0){
        tokenAmount=amount*(tokenInvestedAmount[tokens[i]]*1000000000000000000/investedBalance)/1000000000000000000;
        swapInternal(BUSD,tokens[i],tokenAmount,10);
        tokenInvestedAmount[tokens[i]]+=tokenAmount;
          if(tokens[i]!=address(0x0))
            tokenBalances[tokens[i]]=IERC20(tokens[i]).balanceOf(address(this));
          else tokenBalances[tokens[i]]=address(this).balance;
      }
    }
    tokenBalances[BUSD]=IERC20(BUSD).balanceOf(address(this));
    tokenInvestedAmount[BUSD]=tokenBalances[BUSD];
    if(!userExist[msg.sender]){
      userExist[msg.sender]=true;
      users.push(msg.sender);
    }
  }

  function close() public onlyOwner{
    isClosed=true;
  }

  /**
   * Withdraws the user whole balance.
   */
  function withdraw() public{
    IERC20 tokenInstance;
    uint256[] memory feesAmounts;
    address[] memory feesUsers;
    uint j;
    uint256 BUSDAmount;
    uint256 totalFees;
    uint256 tokenBalance;
    address[] memory path=new address[](2);
    IPancakeRouter02 router=IPancakeRouter02(PSWAP);
    for(j=0;j<tokens.length;j++){
        if(tokenBalances[tokens[j]]!=0){
          tokenBalance=getUserTokenBalance(msg.sender,tokens[j]);
          if(tokenBalance>0){
            if(tokens[j]!=BUSD){
              if(tokens[j]==address(0x0)) path[0]=WBNB;
              else path[0]=tokens[j];
              path[1]=BUSD;
              BUSDAmount=router.getAmountsOut(tokenBalance,path)[1];
              swapInternal(tokens[j],BUSD,tokenBalance,10);
            }
            else BUSDAmount=tokenBalance;
            investedBalance-=BUSDAmount;
            tokenInvestedAmount[tokens[j]]-=BUSDAmount;
            (feesAmounts,feesUsers)=fees(msg.sender,BUSDAmount);
            totalFees=sendFees(feesUsers,feesAmounts);
            BUSDAmount-=totalFees;
            tokenInstance=IERC20(BUSD);
            tokenInstance.approve(msg.sender,BUSDAmount);
            tokenInstance.transfer(msg.sender,BUSDAmount);
            tokenBalances[tokens[j]]-=tokenBalance;
          }
        }
      }
      deposits[msg.sender]=0;
    }

  /**
   * Withdraws the user profit.
   */

  function withdrawStake() public {
    int256 amount;
    amount=int256(getProfit(msg.sender));
    require(amount>0,"No profit.");
    if(amount>0){
      getProfitAndUpdate(msg.sender);
    }
  }

  /**
   * Swap a given amount of a token to another one.
   * @param from The token to be swapped.
   * @param to The token to be received.
   * @param toSwap The amount to be swapped. 
   */
  function swap(address from,address to,uint256 toSwap,uint slippage) public onlyOwner {
    require(from!=to,"From address must be different from to");
    uint i;
    bool flag=false;
    address[] memory path=new address[](2);
    IPancakeRouter02 router=IPancakeRouter02(PSWAP);
    require(tokensValid[to]);
    uint256 deltaBUSD;
    flag=false;
    if(from!=BUSD){
      if(from!=address(0x0)) path[0]=from;
      else path[0]=WBNB;
      path[1]=BUSD;
      deltaBUSD=router.getAmountsOut(toSwap,path)[1];
    }
    else{
      deltaBUSD=toSwap;
    }
    tokenInvestedAmount[from]-=deltaBUSD;
    tokenInvestedAmount[to]+=deltaBUSD;
    swapInternal(from,to,toSwap,slippage);
    tokenBalances[from]-=toSwap;
    if(to!=address(0x0))
      tokenBalances[to]=IERC20(to).balanceOf(address(this));
    else tokenBalances[to]=address(this).balance;
    emit Swapped(toSwap);

  }
  function getUserBalance(address user) public view returns(uint256){
    return deposits[user];
  }
    function swapInternal(address from,address to,uint256 toSwap,uint slippage) private{
    address[] memory path=new address[](2);
    IPancakeRouter02 router=IPancakeRouter02(PSWAP);
    IERC20 tokenInstance;
    uint256 minAmount=toSwap-toSwap/slippage;
    uint256 minAmountConverted;
    if(from==address(0x0)){
      path[0]=address(WBNB);
      path[1]=address(to);
      if(minAmount!=0)       minAmountConverted=router.getAmountsOut(minAmount,path)[1];
      router.swapExactETHForTokensSupportingFeeOnTransferTokens{value:toSwap}(minAmountConverted,path,address(this),block.timestamp + 100);
    }
    else{
      tokenInstance=IERC20(from);
      tokenInstance.approve(PSWAP,toSwap);
      if(to==address(0x0)){
        path[0]=address(from);
        path[1]=address(WBNB);
        if(minAmount!=0)       minAmountConverted=router.getAmountsOut(minAmount,path)[1];
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(toSwap,minAmountConverted,path,address(this),block.timestamp + 100);
      }
      else{
        
        path[0]=address(from);
        path[1]=address(to);
        if(minAmount!=0)       minAmountConverted=router.getAmountsOut(minAmount,path)[1];
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(toSwap,minAmountConverted,path,address(this),block.timestamp + 100);

      }
    }
  }
  /**
   * Returns the profit made by an user.
   *
   */
  function getProfit(address user) public view returns (int256){
      int256 profit=0;
      for(uint i=0;i<tokens.length;i++){
         if(tokens[i]!=BUSD){
            profit+=getTokenProfit(user,tokens[i]);
          }
      }
      return profit;
  }
  function getTokenProfit(address user,address token) public view returns (int256){
      require(token!=BUSD,"BUSD can't produce profit");
      int256 profit=0;
      uint256 price;
      address[] memory path=new address[](2);
      IPancakeRouter02 router=IPancakeRouter02(PSWAP);
      uint256 totalBalance=getTotalBalance();
      uint256 tokenBalance;
      if(token!=address(0x0)) path[0]=token;
      else path[0]=WBNB;
      path[1]=BUSD;
      tokenBalance=getUserTokenBalance(user,token);
      if(tokenBalance!=0){
          profit+=(int256(router.getAmountsOut(tokenBalance,path)[1]))-int256(deposits[user]*(tokenInvestedAmount[token]*1000000000000000000/investedBalance)/1000000000000000000);
      }
      return profit;
  }
  function getUserTokenBalance(address user, address token) public view returns (uint256){
    address[] memory path=new address[](2);
    uint256 USDAmount;
    if(token==address(0x0)) path[0]=WBNB;
    else path[0]=token;
    path[1]=BUSD;
    IPancakeRouter02 router=IPancakeRouter02(PSWAP);
    if(tokenBalances[token]==0) return 0;
    return tokenBalances[token]*(deposits[user]*1000000000000000000/investedBalance)/1000000000000000000;
  }
  function getProfitAndUpdate(address user) private{
      int256 profit=0;
      IERC20 tokenInstance;
      address[] memory usersFee;
      uint256[] memory feesAmounts;
      address[] memory path=new address[](2);
      IPancakeRouter02 router=IPancakeRouter02(PSWAP);
      uint256 tokenAmount;
      uint256 BUSDAmount;
      uint256 tokenBalance;
      uint256 totalFees;
      for(uint i=0;i<tokens.length;i++){
        tokenBalance=getUserTokenBalance(user,tokens[i]);
        if(tokens[i]!=BUSD&&tokenBalance!=0){
          if(tokens[i]==address(0x0)) path[0]=WBNB;
          else path[0]=tokens[i];
          path[1]=BUSD;
          profit=getTokenProfit(user,tokens[i]);
          if(profit>0){ 
                  path[0]=BUSD;
                  if(tokens[i]==address(0x0)) path[1]=WBNB;
                  else path[1]=tokens[i];
                  profit=int256(router.getAmountsOut(uint256(profit),path)[1]);
                  if(tokens[i]==address(0x0)) path[0]=WBNB;
                  else path[0]=tokens[i];
                  path[1]=BUSD;
                  BUSDAmount=uint256(profit);
                  deposits[user]-=BUSDAmount;
                  (feesAmounts,usersFee)=fees(referrers[user],BUSDAmount);
                  totalFees=sendFees(usersFee,feesAmounts);
                  BUSDAmount-=totalFees;
                  tokenInstance=IERC20(BUSD);
                  tokenInstance.approve(user,uint256(profit));
                  tokenInstance.transfer(user,uint256(profit));
                  tokenBalances[tokens[i]]-=uint256(profit);
                  if(tokens[i]!=address(0x0))
                    tokenBalances[tokens[i]]=IERC20(tokens[i]).balanceOf(address(this));
                  else tokenBalances[tokens[i]]=address(this).balance;
            }

        emit WithdrawnProfit(int256(profit));
        }
      }

  }

  function sendFees(address[] memory usersFee, uint256[] memory feesAmounts) private returns (uint256){
          uint256 j;
          IERC20 tokenInstance;
          uint256 amount;
          for(j=0;j<feesAmounts.length;j++){
              if(usersFee[j]!=address(0x0)){
                  tokenInstance=IERC20(BUSD);
                  tokenInstance.approve(usersFee[j],uint256(feesAmounts[j]));
                  tokenInstance.transfer(usersFee[j],uint256(feesAmounts[j]));
                  amount+=feesAmounts[j];
              }
          }
          return amount;
  }
  function fees(address referrer,uint256 amount) private view returns (uint256[] memory,address[] memory){
    uint256[] memory feesAmount=new uint256[](3);
    address[] memory feesAddresses=new address[](3);
    feesAmount[0]=SafeMath.div(amount,5);
    feesAddresses[0]=owner;
    feesAmount[1]=SafeMath.div(amount,5);
    feesAddresses[1]=DEV;
    if(referrer!=address(0x0)){
      feesAmount[2]=SafeMath.div(amount,5);
    }
    feesAddresses[2]=referrer;
    return (feesAmount,feesAddresses);
  }
  /**
   * Returns the amount in USD of the balance of all tokens in the pool
   */
   function getTotalBalance() public view returns (uint256) {
       uint256 totalBalance;
      address[] memory path=new address[](2);
      IPancakeRouter02 router=IPancakeRouter02(PSWAP);
       uint i;
       for(i=0;i<tokens.length;i++){
         if(tokenBalances[tokens[i]]>0){
          if(tokens[i]==BUSD) totalBalance+=tokenBalances[tokens[i]];
          else{
            if(tokens[i]==address(0x0)) path[0]=WBNB;
            else path[0]=tokens[i];
            path[1]=BUSD;
            totalBalance+=router.getAmountsOut(tokenBalances[tokens[i]],path)[1];
          }
         }
       }
       return totalBalance;
   }
  /**
   * Returns all the tokens enabled in the pool
   */
  function getTokens() public view returns (address[] memory){
    return tokens;
  }
  /**
   * Will return the balance of the user for the given token
   * @param user The user to look up for balance
   * @param token The token to look up for balance
   */
  function getUserDeposit(address user,address token) public view returns (uint256){
      return deposits[user];
    }
    /**
      * Returns all the users in the pool
      */
    function getUsers() public view returns (address[] memory){
      return users;
    }
    /**
     * Returns the balance of the selected token
     * @param token The token to look up for balance
     */
    function getTokenBalance(address token) public view returns (uint256){
      return tokenBalances[token];
    }
    
}
contract MotherContract {
  address public BUSD = 0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7;

  mapping (address=>address[]) ownedPools;
  address[] pools;
  constructor(){

  }

  /**
   *  Will create a pool with the given name and the given BUSD amount.
   * @param amount The amount of BUSD to initialize the pool. At least 500.
   * @param name The name of the pool.
   */

  function createPool(uint256 amount,string memory name) public {
    IERC20 busd=IERC20(BUSD);
    Pool pool;
    require(amount>=1000000000000000);
    pool=new Pool(address(msg.sender),name,0xbf0b7Db85Ddbd8760B087144331Db8957b984a35);
    busd.transferFrom(msg.sender,address(this),amount);
    busd.approve(address(pool),amount);
    pool.init(amount);
    pools.push(address(pool));
    ownedPools[msg.sender].push(address(pool));
  }
  /**
   * Will find which pools does the user own.
   * @param user The user to lookup to find which pools own.
   */
  function getUserPools(address user) public view returns (address[] memory){
    return ownedPools[user];
  }
  /**
   * Will find all the pools.
   * 
   */
  function getPools() public view returns(address[] memory){
      return pools;
  }
}

