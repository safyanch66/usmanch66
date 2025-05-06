// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC3156FlashBorrower} from "../../../interfaces/IERC3156FlashBorrower.sol";
import {IERC3156FlashLender} from "../../../interfaces/IERC3156FlashLender.sol";
import {ERC20} from "../ERC20.sol";

/// @title ERC20FlashMint - Minimal flash loan implementation compliant with ERC-3156
abstract contract ERC20FlashMint is ERC20, IERC3156FlashLender {
    bytes32 private constant RETURN_VALUE = keccak256("ERC3156FlashBorrower.onFlashLoan");

    error ERC3156UnsupportedToken(address token);
    error ERC3156ExceededMaxLoan(uint256 maxLoan);
    error ERC3156InvalidReceiver(address receiver);

    function maxFlashLoan(address token) public view virtual override returns (uint256) {
        return token == address(this) ? type(uint256).max - totalSupply() : 0;
    }

    function flashFee(address token, uint256 amount) public view virtual override returns (uint256) {
        if (token != address(this)) revert ERC3156UnsupportedToken(token);
        return _flashFee(token, amount);
    }

    function _flashFee(address, uint256) internal view virtual returns (uint256) {
        return 0; // Default is zero fee
    }

    function _flashFeeReceiver() internal view virtual returns (address) {
        return address(0); // Fee burned by default
    }

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) public virtual override returns (bool) {
        if (token != address(this)) revert ERC3156UnsupportedToken(token);

        uint256 maxLoan = maxFlashLoan(token);
        if (amount > maxLoan) revert ERC3156ExceededMaxLoan(maxLoan);

        uint256 fee = flashFee(token, amount);

        _mint(address(receiver), amount);

        bytes32 result = receiver.onFlashLoan(msg.sender, token, amount, fee, data);
        if (result != RETURN_VALUE) revert ERC3156InvalidReceiver(address(receiver));

        _spendAllowance(address(receiver), address(this), amount + fee);

        if (fee > 0 && _flashFeeReceiver() != address(0)) {
            _transfer(address(receiver), _flashFeeReceiver(), fee);
        }

        return true;
    }
}
