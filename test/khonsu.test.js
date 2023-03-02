const LiquidityPool = artifacts.require("./LiquidityPool")
const MotherContract = artifacts.require("./MotherContract")
const TokenizedPool = artifacts.require("./TokenizedPool")
const ERC1155FromLP = artifacts.require("./ERC1155FromLP")
const IERC20 = artifacts.require("./IERC20")
const fetch = require('node-fetch')


const USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
const SHIBAINU = '0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE';
const GENESIS = '0x0000000000000000000000000000000000000000';
const DAI = '0x6B175474E89094C44Da98b954EedeAC495271d0F';
const MATIC = '0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0';
const ROUTER = '0x1111111254fb6c44bAC0beD2854e76F90643097d';
const ETH = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE';
//const Spreader = artifacts.require("Spreader")

const SWAP_API_ENDPOINT = 'https://api.1inch.io/v4.0/1/swap'
const QUOTE_API_ENDPOINT = 'https://api.1inch.io/v4.0/1/quote'
const TX_API_ENDPOINT = 'https://tx-gateway.1inch.io/v1.1/1/broadcast'

require('chai')
    .use(require('chai-as-promised'))
    .should()

function apiRequestUrl(url, queryParams) {    return url + '?' + (new URLSearchParams(queryParams)).toString();}

contract('MotherContract',([deployer, user]) => {
    let motherContract;
    describe('Deployment and pool creation',async () => {
        before(async () => {
            lpTemplate = await LiquidityPool.new();
            lpTokenTemplate = await TokenizedPool.new();
            lpErc1155Template = await ERC1155FromLP.new()
            //const NFT_MINT_DATE = (Date.now() + milliseconds).toString().slice(0, 10)
            motherContract = await MotherContract.new(lpTemplate.address,lpTokenTemplate.address,lpErc1155Template.address)

           // timeDeployed = NFT_MINT_DATE - Number(milliseconds.toString().slice(0, 3))
        })

        it('Should create a pool', async () => {
            await motherContract.createPoolETH(
                web3.utils.toWei('1', 'ether'),//TO WEI
                'TEST POOL #1',
                '0',
                '0',
                { value: web3.utils.toWei('1', 'ether'), },
            )
            let pools = await motherContract.getPools();
            expect(pools).to.have.lengthOf(1); // Recommended
        })
    })
})

contract('TokenizedPool',([deployer, user]) => {
    let motherContract;
    let pools;
    describe('Pool creation and tokenization',async () => {
        before(async () => {
            lpTemplate = await LiquidityPool.new();
            lpTokenTemplate = await TokenizedPool.new();
            lpErc1155Template = await ERC1155FromLP.new()
            //const NFT_MINT_DATE = (Date.now() + milliseconds).toString().slice(0, 10)
            motherContract = await MotherContract.new(lpTemplate.address,lpTokenTemplate.address,lpErc1155Template.address)
            await motherContract.createPoolETH(
                web3.utils.toWei('1', 'ether'),//TO WEI
                'TEST POOL #1',
                '0',
                '0',
                { value: web3.utils.toWei('1', 'ether'), },
            )
            pools = await motherContract.getPools();
            expect(pools).to.have.lengthOf(1); // Recommended
        })

        it('Should estimate a 1 ETH withdraw',async () => {
            lpToken = await TokenizedPool.at(await (await LiquidityPool.at(pools[0])).lpToken());
            let res = await lpToken.estimateWithdraw(
                GENESIS,
                web3.utils.toWei('1', 'ether')
            )
            console.log(res.toString());
        })


    })


})

contract('ERC1155FromLP',([deployer, user]) => {
    let motherContract;
    let pools;
    describe('ERC1155 Deployment',async () => {
        before(async () => {
            lpTemplate = await LiquidityPool.new();
            lpTokenTemplate = await TokenizedPool.new();
            lpErc1155Template = await ERC1155FromLP.new()
            //const NFT_MINT_DATE = (Date.now() + milliseconds).toString().slice(0, 10)
            motherContract = await MotherContract.new(lpTemplate.address,lpTokenTemplate.address,lpErc1155Template.address)
            await motherContract.createPoolETH(
                web3.utils.toWei('1', 'ether'),//TO WEI
                'TEST POOL #1',
                '0',
                '0',    
                { value: web3.utils.toWei('1', 'ether'), },
            )
            pools = await motherContract.getPools();
            expect(pools).to.have.lengthOf(1); // Recommended
        })
        it('Should create an NFT that is claimable by all pool users', async () => {
            let pool = await LiquidityPool.at(pools[0]);
            let erc1155;
            await pool.createERC1155('test.test/{id}');
            (await pool.lpErc1155()).should.not.equal('0x0000000000000000000000000000000000000000');
            erc1155 = await ERC1155FromLP.at(await pool.lpErc1155());
            await pool.claimERC1155();
            (await erc1155.balanceOf(deployer,1)).toString().should.equal('1')
        })
    })
})

contract('LiquidityPool',([deployer, user]) => {
    let motherContract;
    let pools;
    let pool;
    before (async () => {
        lpTemplate = await LiquidityPool.new();
        lpTokenTemplate = await TokenizedPool.new();
        lpErc1155Template = await ERC1155FromLP.new()
        //const NFT_MINT_DATE = (Date.now() + milliseconds).toString().slice(0, 10)
        motherContract = await MotherContract.new(lpTemplate.address,lpTokenTemplate.address,lpErc1155Template.address)

       // timeDeployed = NFT_MINT_DATE - Number(milliseconds.toString().slice(0, 3))
    })

    it('Should create a pool', async () => {
        await motherContract.createPoolETH(
            web3.utils.toWei('1', 'ether'),//TO WEI
            'TEST POOL #1',
            '0',
            '0',
            { value: web3.utils.toWei('1', 'ether') },
        )
        pools = await motherContract.getPools();
        expect(pools).to.have.lengthOf(1); // Recommended
        pool = await LiquidityPool.at(pools[0]);
    })

    it('Should create a pool with Token', async () => {
        let token = await TokenizedPool.at(await (await LiquidityPool.at(pools[0])).lpToken());
        await token.approve(motherContract.address, web3.utils.toWei('0.001', 'ether'))
        await motherContract.createPool(
            web3.utils.toWei('0.001', 'ether'),//TO WEI
            'TEST POOL #1',
            token.address,
            '0',
            '0',
        )
        pools = await motherContract.getPools();
        expect(pools).to.have.lengthOf(1); // Recommended
        (await token.balanceOf(pools[0])).toString().should.equal(web3.utils.toWei('0.001', 'ether').toString())
    })

    describe('Deposit',async () => {

        it('Should deposit in the pool', async () => {
            let receipt = await pool.deposit(
                GENESIS,
                web3.utils.toWei('1', 'ether'),
                { value: web3.utils.toWei('1', 'ether') }
            );
            (await web3.eth.getBalance(pool.address)).toString().should.equal(web3.utils.toWei('2', 'ether'));
            //(await pool.tokenInvestedAmount(GENESIS)).toString().should.equal(web3.utils.toWei('2', 'ether'));
            //(await pool.investedAmount()).toString().should.equal(web3.utils.toWei('2', 'ether'));
        })
    })

    describe('Withdraw',async ()=> {
        it('Should withdraw from the pool', async () => {
            let receipt = await pool.withdraw(
                GENESIS,
                web3.utils.toWei('2', 'ether')
            );
            (await web3.eth.getBalance(pool.address)).toString().should.equal(web3.utils.toWei('0', 'ether'));
            //(await pool.tokenInvestedAmount(GENESIS)).toString().should.equal(web3.utils.toWei('1', 'ether'));
            //(await pool.investedAmount()).toString().should.equal(web3.utils.toWei('1', 'ether'));
        })
    })

    describe('Swap',async () => {
        it('Should swap 1 ETH to SHIB', async () => {
            const swapParams = {    
                fromTokenAddress: ETH,
                toTokenAddress: MATIC,    
                amount: web3.utils.toWei('0.001', 'ether'),    
                fromAddress: user,    
                slippage: 5,    
                disableEstimate: true,    
                allowPartialFill: true,
            };
            const quoteParams = {
                fromTokenAddress: ETH,
                toTokenAddress: SHIBAINU,    
                amount: web3.utils.toWei('1', 'ether'),   
            }
            let res_tx = await fetch(apiRequestUrl(SWAP_API_ENDPOINT,swapParams)).then(res => res.json()).then(res => res.tx);
            res_tx.should.not.equal(undefined)
            res_tx.gas = '100000';
            res_tx.gasLimit = '1099511627775';
            res_tx.gasPrice = '100064'
            res_tx.nonce = await web3.eth.getTransactionCount(user, 'latest');
            let signedTx = await web3.eth.signTransaction(res_tx,user);
            await web3.eth.sendSignedTransaction(signedTx)
            
        })
        it('Should approve 1 SHIB to USDT',async ()=>{
            await pool.approveSwap(
                SHIBAINU,
                USDT,
                web3.utils.toWei('1', 'ether')
            )
            let token = await IERC20.at(SHIBAINU);
            (await token.allowance(pool.address,ROUTER)).toString().should.equal(web3.utils.toWei('1', 'ether'))
        })

        it('Should approve 1 ETH to USDT',async ()=>{
            await pool.approveSwap(
                GENESIS,
                USDT,
                web3.utils.toWei('1', 'ether')
            )
            //let token = await IERC20.at(SHIBAINU);
            //(await token.allowance(pool.address,ROUTER)).toString().should.equal(web3.utils.toWei('1', 'ether'))
        })
        it('Should swap from the pool ETH to USDT', async () => {
            const swapParams = {    
                fromTokenAddress: ETH,
                toTokenAddress: USDT,    
                amount: web3.utils.toWei('0.001', 'ether'),    
                fromAddress: user,    
                slippage: 5,    
                disableEstimate: true,    
                allowPartialFill: true,
            };
            let res_tx = await fetch(apiRequestUrl(SWAP_API_ENDPOINT,swapParams)).then(res => res.json()).then(res => res.tx);
            let token = await IERC20.at(USDT);
            await pool.swap(res_tx.data,'0')
            (await token.balanceOf(pool.address)).should.not.equal('0')
        })

    })
    describe('Tracking',async () => {
        it('Should track latest transactions',async () => {
            (await pool.txs('1')).isDeposit.should.equal(true)
        })
    })

})


