const POOL_ADDRESS = '0x...'
const POOL_ABI = []

const MOTHER_ADDRESS = '0x...'
const MOTHER_ABI = []


const getPoolContract=async(web3)=>{
    return await web3.eth.Contract(POOL_ABI,POOL_ADDRESS)
}

const getMotherContract=async(web3)=>{
    return await web3.eth.Contract(MOTHER_ABI,MOTHER_ADDRESS)
}

const createPool=async (contract,amount,name,caller)=>{
    return await contract.methods.createPool(amount,name).send({from:caller});
}

const getUserPools=async (contract,user)=>{
    return await contract.methods.getUserPools(user).call()
}
const getPools=async (contract)=>{
    return await contract.methods.getPools().call();
}
/*const getProfit=async (contract,user)=>{
    return await contract.methods.getProfit(user).call();
}*/

const deposit=async(contract,referrer,amount,etherAmount,caller)=>{
    return await contract.methods.addFunds(referrer,amount).send({from:caller,value:etherAmount});
}
/*const swap=async(contract,from,to,toSwap,slippage,caller)=>{
    return await contract.methods.swap(from,to,toSwap,slippage).send({from:caller});
}

const withdrawStake=async(contract,caller)=>{
    return await contract.methods.withdrawStake().send({from:caller});
}

const withdraw=async(contract,caller)=>{
    return await contract.methods.withdraw().send({from:caller});
}

const checkAddress=async(contract,addressToVerify,caller)=>{
    return await contract.methods.checkAddress(addressToVerify).send({from:caller});
}*/


const getTotalBalance=async(contract)=>{
    return await contract.methods.getTotalBalance().call();
}

/*
const getTokens=async(contract)=>{
    return await contract.methods.getTokens().call();
}

const getTokensVerified=async(contract)=>{
    return await contract.methods.getTokensVerified().call();
}*/

const tokenize=async(contract,symbol,caller)=>{
    return await contract.methods.tokenize(symbol).send({from:caller})
}
const getName=async(contract)=>{
    return await contract.methods.name().call();
}

/*const getTokenBalance=async(contract,token)=>{
    return await contract.methods.tokenBalances(token).call();
}
const getTokenProfit=async(contract,token)=>{
    return await contract.methods.getTokenProfit(token).call();
}
const getPrice=async(contract,token)=>{
    return await contract.methods.getPrice(token).call();
}*
const getUsers=async(contract)=>{
    return await contract.methods.getUsers().call()
}

const getUserBalance=async(contract,user)=>{
    return await contract.methods.getUserBalance(user).call()
}*/

const investedBalance=async(contract)=>{
    return await contract.methods.investedBalance().call()
}

export {
    getPoolContract,
    getMotherContract,
    createPool,
    deposit,
    //getProfit,
    //swap,
    //withdrawStake,
    //withdraw,
    getTotalBalance,
    //getTokens,
    getPools,
    getUserPools,
    //getTokensVerified,
    getName,
    tokenize,
    //getPrice,
    //checkAddress,
    //getTokenBalance,
    //getTokenProfit,
    //getUsers,
    //getUserBalance,
    investedBalance
}

