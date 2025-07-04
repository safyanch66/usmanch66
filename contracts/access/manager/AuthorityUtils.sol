// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {IAuthority} from "./IAuthority.sol";

library AuthorityUtils {
    /**
     * @dev Since `AccessManager` implements an extended IAuthority interface, invoking `canCall` with backwards compatibility
     * for the preexisting `IAuthority` interface requires special care to avoid reverting on insufficient return data.
     * This helper function takes care of invoking `canCall` in a backwards compatible way without reverting.
     */
    function canCallWithDelay(
        address authority,
        address caller,
        address target,
        bytes4 selector
    ) internal view returns (bool immediate, uint32 delay) {
        bytes memory data = abi.encodeCall(IAuthority.canCall, (caller, target, selector));

        assembly ("memory-safe") {
            mstore(0x00, 0x00)
            mstore(0x20, 0x00)

            if staticcall(gas(), authority, add(data, 0x20), mload(data), 0x00, 0x40) {
                immediate := mload(0x00)
                delay := mload(0x20)

                // If delay does not fit in a uint32, return 0 (no delay)
                // equivalent to: if gt(delay, 0xFFFFFFFF) { delay := 0 }
                delay := mul(delay, iszero(shr(32, delay)))
            }
        }
    }
}
