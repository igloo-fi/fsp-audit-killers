// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


interface IFSPAuditKillers
{
	/* [event] */
    event PauseUpdated(bool pause);

	
	/**
     * @notice Get baseURI
     * @dev [!restriction]
     * @dev [view]
	 * @return {string} baseURI
    */
    function baseURI() external view returns (string memory);

	/**
     * @notice Get the current token id (final should be 9999)
     * @dev [!restriction]
     * @dev [view]
	 * @return {uint8} current token id
    */
    function tokenIdTracker() external view returns (uint8);
	

	/**
     * @notice Return is whitelisted value
     * @dev [!restriction]
     * @dev [view]
     * @param target {address} Address to check if whitelisted
	 * @return {bool} whitelisted status
    */
    function isWhitelisted(address target) external view returns (bool);

	/**
     * @notice Return minted count
     * @dev [!restriction]
     * @dev [view]
     * @param target {address}
	 * @return {uint8} Minted count
    */
    function minted(address target) external view returns (uint8);

	/**
     * @notice Get array of token ids owned by specified address
     * @dev [!restriction]
     * @dev [view]
     * @param target {address}
	 * @return {uint256[]} Array of token ids
    */
	function walletOwnerOf(address target)
        external
        view
        returns (uint256[] memory)
    ;

	/**
     * @notice Mint a token
     * @dev [!restriction]
     * @dev [increment] `tokenIdTracker`
	 *      [mint]
     *      [increment] `_minted`
	 * 
    */
	function mint() external payable;

	/**
     * @notice Set `baseURI`
     * @dev [restriction] owner
     * @dev [update] `baseURI`
     * @param newBaseURI {string} New `baseURI`
    */
	function setBaseURI(string memory newBaseURI) external;

	/**
     * @notice Set the state of `_paused`
     * @dev [restriction] owner
     * @dev [update] `_paused`
     * @param paused {bool} State of `paused`
    */
	function setPaused(bool paused) external;

	/**
     * @notice Set price
     * @dev [restriction] owner
     * @dev [update] `price`
     * @param newPrice {uint256} New price
    */
	function setPrice(uint256 newPrice) external;

	/**
     * @notice Add an address to _whitelist
     * @dev [restriction] owner
     * @dev [update] `_whitelist`
     * @param target {address} to be withdrawn too
    */
	function whitelist(address target) external;

	/**
     * @notice Withdraw ETH in this contract
     * @dev [restriction] owner
     * @dev [transfer]
     * @param target {address} to be withdrawn too
     * @param _amount {uint256} to be withdrawn
    */
	function widthdrawETH(address target, uint256 _amount) external;
}