// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/**
 * @dev ERC-2309: ERC-721 Consecutive Transfer Extension.
 */
interface IERC2309 {
    /**
     * @dev Emitted when the tokens from `fromTokenId` to `toTokenId` are transferred from `fromAddress` to `toAddress`.
     */
    event ConsecutiveTransfer(
        uint256 indexed fromTokenId,
        uint256 toTokenId,
        address indexed fromAddress,
        address indexed toAddress
    );
}
