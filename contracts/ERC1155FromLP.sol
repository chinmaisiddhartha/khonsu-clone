// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./extensions/Mintable.sol";

contract ERC1155FromLP is Mintable, ERC1155SupplyUpgradeable {
    using Strings for uint256;

    //string baseURI;
    uint256 public maxMintAmount;
    uint256 public timeDeployed;
    uint256 public allowMintingAfter = 0;
    uint256 public count = 0;
    bool public isPaused = false;
    string public name;
    string public baseUri;
    mapping(uint256=>bool) public isRevealed;

    event Minted(uint256 id, address addr);

    function init(
        uint256 _allowMintingOn,
        string memory _uri,
        string memory _name
    ) external initializer {
        __ERC1155_init(_uri);
        if (_allowMintingOn > block.timestamp) {
            allowMintingAfter = _allowMintingOn - block.timestamp;
        }
        name = _name;
        timeDeployed = block.timestamp;
        baseUri = _uri;
        __Mintable_init(msg.sender);
    }

  
    // internal
    /*
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }*/

    // public

    function mint(address _user) external onlyMinter {
        require(block.timestamp >= timeDeployed + allowMintingAfter, "Minting not allowed yet");

        /*if (msg.sender != owner()) {
            // pay 90% of the value to charity and the rest to the deployer

        }*/
        count++;
        _mint(_user, count, 1, "");
        emit Minted(count,_user);
    }


    function uri(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return string(abi.encodePacked(baseUri,Strings.toString(tokenId),".json"));
    }

    function getSecondsUntilMinting() public view returns (uint256) {
        if (block.timestamp < timeDeployed + allowMintingAfter) {
            return (timeDeployed + allowMintingAfter) - block.timestamp;
        } else {
            return 0;
        }
    }
}
