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
    */
    function baseURI() external view returns (string memory);

	/**
     * @notice Get the current token id (final should be 9999)
     * @dev [!restriction]
     * @dev [view]
    */
    function tokenIdTracker() external view returns (uint8);

	/**
     * @notice Return true if target whitelisted
     * @dev [!restriction]
     * @dev [view]
     * @param target {address} Address to check if whitelisted
    */
    function whitelist(address target) external view returns (bool);

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
    ;

	/**
     * @notice Mint a token
     * @dev [!restriction]
    */
	function mint() external payable;

	/**
     * @notice Set baseURI
     * @dev [restriction] owner 
     * @param newBaseURI New baseURI
    */
	function setBaseURI(string memory newBaseURI) external;

	/**
     * @notice Set the state of `_paused`
     * @dev [restriction] owner
     * @param paused {bool} State of paused
    */
	function setPaused(bool paused) external;

	/**
     * @notice Add an address to _whitelist
     * @dev [restriction] owner
     * @param _address {address} to be withdrawn too
    */
	function addToWhitelist(address _address) external;

	/**
     * @notice Withdraw ETH in this contract
     * @param _address {address} to be withdrawn too
     * @param _amount {uint256} to be withdrawn
    */
	function widthdrawETH(address _address, uint256 _amount) external;
}