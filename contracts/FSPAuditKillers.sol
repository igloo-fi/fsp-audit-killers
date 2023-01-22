// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* [import][foreign] */
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
    uint256 public constant PRICE = 0.01 ether;

    string public baseURI;
    uint8 public tokenIdTracker;

    /* [private] */
    bool private _paused;
    
    /* [mapping] */
    mapping (address => bool) internal _whitelist;


    /* [constructor] */
    constructor (string memory initialBaseURI)
        ERC721("FSP Audit Killers", "FSP")
    {
        _paused = true;

        setBaseURI(initialBaseURI);
        
        tokenIdTracker = 0;
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
    function whitelist(address target)
        public
        view
        returns (bool)
    {
        return _whitelist[target];
    }
    
    /// @inheritdoc IFSPAuditKillers
    function walletOwnerOf(address _owner)
        public
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

    /// @inheritdoc IFSPAuditKillers
    function mint()
        public
        payable
    {
        require(tokenIdTracker < MAX_SUPPLY, "Max supply reached");
        require(_paused == false || _whitelist[msg.sender], "Mint paused");
        require(msg.value >= PRICE || _whitelist[msg.sender],  "!msg.value");

        // [increment]
        tokenIdTracker++;

        // [mint]
        _safeMint(_msgSender(), tokenIdTracker);
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
    function addToWhitelist(address _address)
        public
        onlyOwner()
    {
        _whitelist[_address] = true;
    }

    /// @inheritdoc IFSPAuditKillers
    function widthdrawETH(address _address, uint256 _amount)
        public
        onlyOwner()
    {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }
}
