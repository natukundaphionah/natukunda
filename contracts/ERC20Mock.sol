// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mock is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply) 
        ERC20(name, symbol) // Pass the name and symbol to the ERC20 base contract
    {
        _mint(msg.sender, initialSupply); // Mint initial supply to the contract deployer
    }

    // Function to mint additional tokens if needed for tests
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
