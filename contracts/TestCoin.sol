// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract TestCoin is ERC20 {

    // 1 Billion total supply
    uint tokenTotalSupply = 1000000000;

    constructor() ERC20("Test Coin", "TEST") {
        _mint(msg.sender, tokenTotalSupply * (10 ** uint256(decimals())));
    }
}