// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {IERC20} from "./IERC20.sol";

/**
 * @dev Temporary Approval Extension for ERC-20 (https://github.com/ethereum/ERCs/pull/358[ERC-7674])
 */
interface IERC7674 is IERC20 {
    /**
     * @dev Set the temporary allowance, allowing `spender` to withdraw (within the same transaction) assets
     * held by the caller.
     */
    function temporaryApprove(address spender, uint256 value) external returns (bool success);
}
