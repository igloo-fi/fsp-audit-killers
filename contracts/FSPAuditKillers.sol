// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* [import] */
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/* [import][domestic] */
import "./interface/IFSPAuditKillers.sol";


/**
 * @title FSPAuditKillers
 * @notice NFTs for the Friendly Stock Picks Audit Killers
*/
contract FSPAuditKillers is
    IFSPAuditKillers,
    ERC721Enumerable,
    Ownable
{
    /* [using] */
    using SafeMath for uint256;


    /* [public][constant] */
    uint256 public constant MAX_SUPPLY = 10000;

    string public baseURI;
    uint8 public tokenIdTracker;
    uint256 public price;

    /* [private] */
    bool private _paused;
    
    /* [mapping] */
    mapping (address => bool) internal _whitelist;
    mapping (address => uint8) internal _minted;


    /* [constructor] */
    constructor (string memory initialBaseURI)
        ERC721("FSP Audit Killers", "FSP")
    {
        _paused = true;

        setBaseURI(initialBaseURI);

        tokenIdTracker = 0;
        
        price = 0.01 ether;
    }


    /* [function] */
    /**
     * @notice Return baseURI
     * @dev [restriction][internal]
    */
    function _baseURI()
        internal
        view
        virtual
        override
        returns (string memory)
    {
        return baseURI;
    }

    /// @inheritdoc IFSPAuditKillers
    function isWhitelisted(address target)
        public
        view
        returns (bool)
    {
        return _whitelist[target];
    }

    /// @inheritdoc IFSPAuditKillers
    function minted(address target)
        public
        view
        returns (uint8)
    {
        return _minted[target];
    }
    
    /// @inheritdoc IFSPAuditKillers
    function walletOwnerOf(address target)
        public
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(target);

        uint256[] memory tokensId = new uint256[](tokenCount);

        for (uint256 i = 0; i < tokenCount; i++)
        {
            tokensId[i] = tokenOfOwnerByIndex(target, i);
        }

        return tokensId;
    }

    /// @inheritdoc IFSPAuditKillers
    function mint()
        public
        payable
    {
        require(tokenIdTracker < MAX_SUPPLY, "Max supply reached");
        require(_paused == false || _whitelist[msg.sender], "Mint paused");
        require(msg.value >= price || _whitelist[msg.sender],  "!msg.value");
        require(_minted[msg.sender] < 3, "3 mints per address");

        // [increment]
        tokenIdTracker++;

        // [mint]
        _safeMint(_msgSender(), tokenIdTracker);

        // [increment]
        if (_minted[msg.sender] > 0)
        {
            _minted[msg.sender]++;
        }
        else
        {
            _minted[msg.sender] = 1;
        }

        emit Minted(msg.sender, tokenIdTracker);
    }

    /// @inheritdoc IFSPAuditKillers
    function setBaseURI(string memory newBaseURI)
        public
        onlyOwner()
    {
        baseURI = newBaseURI;
    }

    /// @inheritdoc IFSPAuditKillers
    function setPaused(bool paused)
        public
        onlyOwner()
    {
        _paused = paused;

        emit PauseUpdated(_paused);
    }


    /// @inheritdoc IFSPAuditKillers
    function setPrice(uint256 newPrice)
        public
        onlyOwner()
    {
        price = newPrice;
    }

    /// @inheritdoc IFSPAuditKillers
    function whitelist(address target)
        public
        onlyOwner()
    {
        _whitelist[target] = true;
    }

    /// @inheritdoc IFSPAuditKillers
    function widthdrawEther(address target, uint256 _amount)
        public
        onlyOwner()
    {
        // [transfer]
        (bool success, ) = target.call{value: _amount}("");
        require(success, "Transfer failed.");

        emit EtherWithdrawn(_amount);
    }
}
