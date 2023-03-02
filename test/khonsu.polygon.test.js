/*const LiquidityPool = artifacts.require("./LiquidityPool")
const MotherContract = artifacts.require("./MotherContract")
const TokenizedPool = artifacts.require("./TokenizedPool")
const ERC1155FromLP = artifacts.require("./ERC1155FromLP")
const IERC20 = artifacts.require("./IERC20")
const fetch = require('node-fetch')


const USDT = '0xc2132D05D31c914a87C6611C10748AEb04B58e8F';
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

contract('LiquidityPool',() => {
    let pool = await LiquidityPool.at('0x5d7e2d2d6B92a56d61ce8430D9A4dE042F7F454c')
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
            let res_tx = await fetch(apiRequestUrl(SWAP_API_ENDPOINT,swapParams)).then(res => res.json()).then(res => res.tx);
            res_tx.should.not.equal(undefined)
            res_tx.gas = '100000';
            res_tx.gasLimit = '1099511627775';
            res_tx.gasPrice = '100064'
            res_tx.nonce = await web3.eth.getTransactionCount(user, 'latest');
            let signedTx = await web3.eth.signTransaction(res_tx,user);
            await web3.eth.sendSignedTransaction(signedTx)
            
        })
        /*it('Should approve 1 SHIB to USDT',async ()=>{
            await pool.approveSwap(
                SHIBAINU,
                USDT,
                web3.utils.toWei('1', 'ether')
            )
            let token = await IERC20.at(SHIBAINU);
            (await token.allowance(pool.address,ROUTER)).toString().should.equal(web3.utils.toWei('1', 'ether'))
        })*/
        /*it('Should swap from the pool ETH to USDT', async () => {
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
})*/