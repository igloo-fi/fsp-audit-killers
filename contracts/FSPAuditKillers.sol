// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* [import][foreign] */
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";


/**
 * @title FSPAuditKillers
 * @notice NFTs for the Friendly Stock Picks Audit Killers
*/
contract FSPAuditKillers is
    ERC721Enumerable,
    Ownable
{
    /* [event] */
    event PauseUpdated(bool pause);


    /* [using] */
    using SafeMath for uint256;


    /* [uint256][public][constant] */
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant PRICE = 0.01 ether;
    /* [bool][private] */
    bool private _paused;
    /* [string][private] */
    string private bURI;
    /* [uint8] */
    uint8 private _tokenIdTracker;
    /* [mapping] */
    mapping (address => bool) public whitelist;


    /* [constructor] */
    constructor (string memory baseURI)
        ERC721("FSP Audit Killers", "FSP")
    {
        _paused = true;

        setBaseURI(baseURI);
        
        _tokenIdTracker = 0;
    }


    /* [function] */
    /**
     * @notice Get id's of tokens owned by provided address
     * @dev [!restriction]
     * @dev [view]
     * @param _owner {address} Address to query with
    */
    function walletOwnerOf(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);

        for (uint256 i = 0; i < tokenCount; i++)
        {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    /**
     * @notice Mint a token
     * @dev [!restriction]
    */
    function mint()
        public
        payable
    {
        require(_tokenIdTracker < MAX_SUPPLY, "Max supply reached");
        require(_paused == false || whitelist[msg.sender], "Mint paused");
        require(msg.value >= PRICE || whitelist[msg.sender],  "!msg.value");

        // [increment]
        _tokenIdTracker++;

        // [mint]
        _safeMint(_msgSender(), _tokenIdTracker);
    }

    /**
     * @notice Return bURI
     * @dev [restriction][internal]
    */
    function _baseURI()
        internal
        view
        virtual
        override
        returns (string memory)
    {
        return bURI;
    }

    /**
     * @notice Set baseURI
     * @dev [restriction]owner 
     * @param newbaseURI New baseURI
    */
    function setBaseURI(string memory newbaseURI)
        public
        onlyOwner()
    {
        bURI = newbaseURI;
    }

    /**
     * @notice Set the state of `_paused`
     * @dev [restriction] owner
     * @param paused {bool} State of paused
    */
    function setPaused(bool paused)
        public
        onlyOwner()
    {
        _paused = paused;

        emit PauseUpdated(_paused);
    }

    /**
     * @notice Add an address to whitelist
     * @dev [restriction] owner
     * @param _address {address} to be withdrawn too
    */
    function addToWhitelist(address _address)
        public
        onlyOwner()
    {
        whitelist[_address] = true;
    }

    /**
     * @notice Withdraw ETH in this contract
     * @param _address {address} to be withdrawn too
     * @param _amount {uint256} to be withdrawn
    */
    function widthdrawETH(address _address, uint256 _amount)
        public
        onlyOwner()
    {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }
}
