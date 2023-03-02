const MotherContract = artifacts.require("MotherContract");
const LiquidityPool = artifacts.require("LiquidityPool");
const ERC1155FromLP = artifacts.require("ERC1155FromLP");
const TokenizedPool = artifacts.require("TokenizedPool");


module.exports = async function (deployer) {
  let liquidityPool = await deployer.deploy(LiquidityPool);
  let tokenizedPool = await deployer.deploy(TokenizedPool);
  let erc1155FromLP = await deployer.deploy(ERC1155FromLP);

  deployer.deploy(MotherContract,LiquidityPool.address,TokenizedPool.address,ERC1155FromLP.address)
};
