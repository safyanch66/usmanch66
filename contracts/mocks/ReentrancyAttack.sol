// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {Context} from "../utils/Context.sol";

contract ReentrancyAttack is Context {
    function callSender(bytes calldata data) public {
        (bool success, ) = _msgSender().call(data);
        require(success, "ReentrancyAttack: failed call");
    }
}
