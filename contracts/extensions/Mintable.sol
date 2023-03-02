// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract Mintable is Initializable {
    address private minter;


    modifier onlyMinter() {
        require(msg.sender==minter,"Mintable: Caller not minter");
        _;
    }

    function __Mintable_init(address _minter) internal onlyInitializing {
        __Mintable_init_unchained(_minter);
    }

    function __Mintable_init_unchained(address _minter) internal {
        minter = _minter;
    }

    function Minter() public view returns (address) {
        return minter;
    }
}