// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "./TokenizedPool.sol";
import "./ERC1155FromLP.sol";
import "./interfaces/IMintable.sol";
import "./interfaces/IPriceFeed.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

struct Deposit {
    uint256 amount;
    address user;
}

struct Withdraw {
    uint256 tokenAmount;
    uint256 tokenToBeBurned;
    address user;
}

struct Swap {
    address from;
    address to;
    uint256 amount;
    uint256 id;
    bool synced;
    address user;
}

struct Transaction {
    bool isSwap;
    bool isDeposit;
    bool isWithdraw;
    Swap swap;
    Withdraw withdraw;
    Deposit deposit;
    uint256 timestamp;
}

contract LiquidityPool is Initializable, OwnableUpgradeable {
    string public name;//Pool name

    address public ROUTER;
    address public UNIROUTER;//Uniswap-like router address
    address[] public tokens;//Pool tokens
    address[] public users;//Users
    address public base;//Pool base currency
    address public lpToken;//Liquidity pool token
    address public lpErc1155;//NFT Collection related to current pool
    address public oracle;//Price feed oracle

    //Contract clones templates
    address public lpTokenTemplate;
    address public lpErc1155Template;
    
    uint256 public createdAt;//Pool creation date
    uint256 public investedAmount;//Total base currency deposited
    uint256 public performanceFees;
    uint256 public maintenanceFees;
    uint256 public tokensLength;
    uint256 public txsLength;
    uint256 public currSwapId;


    bool public ready;

    mapping (address => uint256) public usedSupply;//Withdrawn supply by user
    mapping (address => bool) public userExist;
    mapping (address => bool) public tokenExist;
    mapping (address => Withdraw) public withdrawals;

    Swap[] public swaps;

    Transaction[] public txs;

    event NewOwner(address owner);
    event Tokenized(address tokenAddr);
    event ERC1155Creation(address tokenAddr);
    event ERC20Transfer(address sender,uint256 amount);
    event Deposited(Deposit deposit);
    event Swapped(Swap swap);
    event Withdrawn(Withdraw withdraw);

    /**
        * Initializes pool with native currency.
        * @param owner The pool owner.
        * @param _name The pool name.
        * @param _base The pool base token.
        * @param _lpTokenTemplate The ERC20 token to be created. Contract template to be copied with for minimal proxy.
        * @param _lpErc1155Template The ERC1155 token to be created.
        * @param _performanceFees The fees paid for performances to pool owner.
        * @param _maintenanceFees The fees paid to Khonsu Maintainers.
     */
    function init(address owner,string memory _name, address _base, address _lpTokenTemplate, address _lpErc1155Template, uint256 _performanceFees, uint256 _maintenanceFees) external payable initializer {
        _init(owner,msg.value,_name,_base,_lpTokenTemplate,_lpErc1155Template);
    }
    /**
        * Initializes pool with ERC20 token.
        * @param owner The pool owner.
        * @param amount ERC20 token amount.
        * @param _name The pool name.
        * @param _base The pool base token.
        * @param _lpTokenTemplate The ERC20 token to be created. Contract template to be copied with for minimal proxy.
        * @param _lpErc1155Template The ERC1155 token to be created.
        * @param _performanceFees The fees paid for performances to pool owner.
        * @param _maintenanceFees The fees paid to Khonsu Maintainers.

     */
    function init(address owner, uint256 amount,string memory _name, address _base, address _lpTokenTemplate, address _lpErc1155Template, uint256 _performanceFees, uint256 _maintenanceFees ) external initializer {
        _init(owner,amount,_name,_base,_lpTokenTemplate,_lpErc1155Template);
    }

    /** 
        Creates an ERC20 Token for the pool. It will use pool name as token's name, and supply is equal to amount of init.
        @param symbol The token's symbol.
    */
    function tokenize(string memory symbol) internal{
        require(lpToken==address(0x0),"LP Token already created");
        lpToken = address(new TokenizedPool());
        TokenizedPool(lpToken).init(symbol,address(this));
        TokenizedPool(lpToken).mint(owner(),investedAmount);
        emit Tokenized(lpToken);
    }
    
    /**
     * Internal initialization method.
     */

    function _init(address owner,uint256 amount,string memory _name, address _base, address _lpTokenTemplate, address _lpErc1155Template) internal {
        _transferOwnership(owner);
        ready = true;
        name = _name;
        base = _base;
        lpTokenTemplate = _lpTokenTemplate;
        lpErc1155Template = _lpErc1155Template;
        ROUTER = 0x1111111254fb6c44bAC0beD2854e76F90643097d;
        createdAt = block.timestamp;
        tokenExist[base] = true;
        tokens.push(base);
        tokensLength++;
        tokenize("TEST");
        _deposit(owner,amount);
    }

    /**
     * Creates an ERC1155 from given URI. All pool users' can claim an NFT from this pool.
     * @param uri The ERC1155 URI.
     */

    function createERC1155(string memory uri) external onlyOwner{
        require(lpErc1155==address(0x0),"LP ERC1155 Token already created");
        lpErc1155 = Clones.clone(lpErc1155Template);
        ERC1155FromLP(lpErc1155).init(0,name,uri);
    }

    /**
     * Mints an NFT for a pool investor.
     */
    function claimERC1155() external {
        ERC1155FromLP(lpErc1155).mint(msg.sender);
        emit ERC1155Creation(lpErc1155);
    }

    /**
   * Adds a given amount to the user balance.
   * @param referrer The referral user.
   * @param amount The amount to be credited.
   */
  function deposit(address referrer,uint256 amount) public payable{
    //require(!isClosed);
    //require((amount*getPrice(base)/1000000000000000000)>100000000000000000000);
    //require(amount>=1000000000000000,"Minimum of 100 BUSD");
    /*uint i;
    uint256 tokenAmount;*/

    //referrers[msg.sender]=referrer;
    if(base!=address(0x0)){
        IERC20 tokenInstance=IERC20(base);
        tokenInstance.transferFrom(msg.sender, address(this), amount);
        emit ERC20Transfer(msg.sender,amount);
    }
    //tokenBalances[BUSD]+=amount;

    /*for(i=0;i<tokens.length;i++){
      if(tokens[i]!=BUSD&&tokenBalances[tokens[i]]!=0){
        tokenAmount=amount*(tokenInvestedAmount[tokens[i]]*1000000000000000000/investedBalance)/1000000000000000000;
        swapInternal(BUSD,tokens[i],tokenAmount,10);
        tokenInvestedAmount[tokens[i]]+=tokenAmount;
          if(tokens[i]!=address(0x0))
            tokenBalances[tokens[i]]=IERC20(tokens[i]).balanceOf(address(this));
          else tokenBalances[tokens[i]]=address(this).balance;
      }
    }*/
    _deposit(msg.sender, amount);
  }

  function _deposit(address investor, uint256 amount) internal {
    Deposit memory deposited;
    Transaction memory transaction;
    deposited.amount = amount;
    deposited.user = msg.sender;
    investedAmount+=amount;
    if(lpToken!=address(0x0)){
        IMintable(lpToken).mint(investor, amount);
    }
    if(!userExist[investor]){
        userExist[investor] = true;
        users.push(investor);
    }
    emit Deposited(deposited);
    transaction.isDeposit = true;
    transaction.deposit = deposited;
    transaction.timestamp = block.timestamp;
    txs.push(transaction);
    txsLength++;
  }

    /**
    * The auth level of an user
    * @param user The user to check auth level.
    * @return auth Auth level of an user. 0 means that the user hasn't invested yet. 1 means the user is an investor. 2 means an user is the pool owner.
    */ 
    function userAuth(address user) external view returns (uint8) {
        if (user==owner()) return 2;
        else if (userExist[user]) return 1;
        return 0;
    }

    /**
     * Swap approval. Required before running a swap.
     * @param from Token to swap.
     * @param to Token to be swapped to.
     * @param amount Amount of token to swap.
     */ 
    function approveSwap(address from, address to, uint256 amount) public onlyOwner {
        if (from != address(0x0)) {
            IERC20(from).approve(ROUTER, amount);
        }
        swaps.push(Swap(from, to, amount, swaps.length,false,msg.sender));
        if(!tokenExist[to]) {
            tokens.push(to);
            tokensLength++;
            tokenExist[to] = true;
        }
        currSwapId++;
    }

    /**
     * Synchronization of swap.
     */
    function sync(uint256 swap_id) internal {
        Swap storage _swap;
        Transaction memory transaction;
        _swap = swaps[swap_id];
        require(_swap.id==swap_id,"Not existing swap");
        require(!_swap.synced,"Swap already synced");
            _swap.synced = true;
            emit Swapped(_swap);
            transaction.isSwap = true;
            transaction.swap = _swap;
            transaction.timestamp = block.timestamp;
            txs.push(transaction);
            txsLength++;
    }

    /**
     * Swap function. It uses 1INCH API.
     * @param callData The swap call to 1INCH crafted through their API.
     * @param ethAmount Amount of ETH to Swap.  Keep it at 0 when approved swap's "from" field is address(0x0).
     * @param id Swap id.
     */
    function swap(bytes memory callData, uint256 ethAmount, uint256 id) external onlyOwner{
            (bool success,) = payable(ROUTER).call{value:ethAmount}(callData);
            //require(success,"KHONSU: Swap failed");
            sync(id);
    }
    /**
     * Withdraws a "token" currency, and a given amount of shares.
     * @param token Currency to be withdrawn.
     *
     */
    function withdraw(address token, uint256 amount) external {
        require(amount <= IERC20(lpToken).balanceOf(msg.sender) - withdrawals[msg.sender].tokenToBeBurned);
        uint256 toWithdraw = TokenizedPool(lpToken).estimateWithdraw(token, amount);
        Withdraw memory withdrawn;   
        Transaction memory transaction;
            withdrawn.user = msg.sender;
            withdrawn.tokenAmount = toWithdraw;
            withdrawn.tokenToBeBurned = amount;
        if(token == address(0x0)){
            emit Withdrawn(withdrawn);
            (bool success,) = payable(msg.sender).call{value:toWithdraw}("");
        }else{
            emit Withdrawn(withdrawn);
            IERC20(token).transfer(msg.sender, toWithdraw);
        }
        transaction.withdraw = withdrawn;
        transaction.isWithdraw = true;
        transaction.timestamp = block.timestamp;

        txs.push(transaction);
        txsLength++;

    }

   /*function getTotalBalance() external view returns (uint256) {
    uint256 totalBalance;
    address[] memory path=new address[](2);
    IUniswapV2Router02 router=IUniswapV2Router02(ROUTER);
    uint i;
    for(i=0;i<tokens.length;i++){
        if(IERC20(tokens[i]).balanceOf(address(this))>0){
            if(tokens[i]==base) totalBalance+=IERC20(base).balanceOf(address(this));
        else{
            if(tokens[i]==address(0x0)) path[0]=router.WETH();
            else path[0]=tokens[i];
            path[1]=base;
            totalBalance+=router.getAmountsOut(IERC20(tokens[i]).balanceOf(address(this)),path)[1];
            }
         }
       }
       return totalBalance;
   }*/
   
   function tokensToArr() external view returns (address[] memory) {
       return tokens;
   }

    function usersToArr() external view returns (address[] memory) {
       return users;
   }
}