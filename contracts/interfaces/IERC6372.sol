// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IERC6372 {
    /**
     * @dev Clock used for flagging checkpoints. Can be overridden to implement timestamp based checkpoints (and voting).
     */
    function clock() external view returns (uint48);

    /**
     * @dev Description of the clock
     */
    // solhint-disable-next-line func-name-mixedcase
    function CLOCK_MODE() external view returns (string memory);
}
