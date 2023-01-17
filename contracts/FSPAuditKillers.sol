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
 * @notice NFTs for the Friend Stock Picks Audit Killers
*/
contract FSPAuditKillers is
    ERC721Enumerable,
    Ownable
{
    /* [event] */
    event PauseUpdated(bool pause);


    /* [using] */
    using SafeMath for uint256;
    using Counters for Counters.Counter;


    /* [uint256][public][constant] */
    uint256 public constant TOTAL_SUPPLY = 10000;
    uint256 public constant PRICE = 0.01 ether;
    uint256 public constant START_AT = 1;


    /* [bool][private] */
    bool private _pause;


    /* [string][public] */
    string public baseTokenURI;


    /* [] */
    Counters.Counter private _tokenIdTracker;


    /* [constructor] */
    constructor (string memory baseURI)
        ERC721("FSP Audit Killers", "FSP")
    {
        _pause = true;

        setBaseURI(baseURI);
    }


    /* [modifier] */
    modifier saleIsOpen()
    {
        require(totalToken() <= TOTAL_SUPPLY, "Total reached");
        require(!_pause, "Sales not open");

        _;
    }


    /* [function] */
    function _baseURI()
        internal
        view
        virtual
        override
        returns (string memory)
    {
        return baseTokenURI;
    }


    function price(uint256 _count)
        public
        pure
        returns (uint256)
    {
        return PRICE.mul(_count);
    }


    function setBaseURI(string memory baseURI)
        public
        onlyOwner()
    {
        baseTokenURI = baseURI;
    }


    function totalToken()
        public
        view
        returns (uint256)
    {
        return _tokenIdTracker.current();
    }


    function signatureWallet(
        address wallet,
        uint256[] memory _tokensId,
        uint256 _timestamp,
        bytes memory _signature
    )
        public
        pure
        returns (address)
    {
        return ECDSA.recover(
            keccak256(abi.encode(wallet, _tokensId, _timestamp)),
            _signature
        );
    }


    function mint(
        uint256[] memory _tokensId,
        uint256 _timestamp,
        bytes memory _signature
    )
        public
        payable
        saleIsOpen()
    {
        require(totalToken() + _tokensId.length <= TOTAL_SUPPLY, "Mint complete");

        require(msg.value >= price(_tokensId.length), "!msg.value");

        address signerOwner = signatureWallet(
            _msgSender(),
            _tokensId,
            _timestamp,
            _signature
        );

        require(signerOwner == owner(), "Not authorized to mint");

        require(block.timestamp >= _timestamp - 30, "Out of time");

        for (uint8 i = 0; i < _tokensId.length; i++)
        {
            require(
                ownerOf(_tokensId[i]) == address(0) &&
                _tokensId[i] > 0 &&
                _tokensId[i] <= TOTAL_SUPPLY,
                "Token already minted"
            );

            _tokenIdTracker.increment();

            _safeMint(_msgSender(), _tokensId[i]);
        }
    }


    function walletOfOwner(address _owner)
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


    function setPause(bool pause)
        public
        onlyOwner()
    {
        _pause = pause;

        emit PauseUpdated(_pause);
    }


    function widthdrawETH(address _address, uint256 _amount)
        public
        onlyOwner()
    {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }
}
