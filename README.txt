UNIT TESTING:

First of all, open two CMD/Powershell terminals. Then, in the first run 

npm run dev

Then, in the other terminal, run:

truffle test --network development

Withdraw may fail due to forked dev network. To fix this, open "./contracts/TokenizedPool.sol", then replace ROUTER address with ETH.

DEPLOYMENT

Create file ".secret" in project root, then run:

truffle migrate --network < matic | ropsten >