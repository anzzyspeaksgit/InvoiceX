// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/FactoringPool.sol";
import "../contracts/InvoiceNFT.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockStablecoin is ERC20 {
    constructor() ERC20("Mock USD", "mUSD") {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract FactoringPoolTest is Test {
    FactoringPool public pool;
    InvoiceNFT public invoiceNFT;
    MockStablecoin public stablecoin;

    address public admin = address(this);
    address public investor = address(0x1);
    address public business = address(0x2);

    function setUp() public {
        stablecoin = new MockStablecoin();
        invoiceNFT = new InvoiceNFT();
        
        // Mock BaseRWA constructor requirements might need to be adjusted based on implementation
        pool = new FactoringPool(address(stablecoin), address(invoiceNFT));

        // Setup roles
        invoiceNFT.grantRole(invoiceNFT.MINTER_ROLE(), admin);
        pool.whitelistInvestor(investor);

        // Setup investor funds
        stablecoin.mint(investor, 10000 * 10 ** 18);
        vm.prank(investor);
        stablecoin.approve(address(pool), 10000 * 10 ** 18);
    }

    function testDeposit() public {
        vm.prank(investor);
        pool.deposit(1000 * 10 ** 18);

        assertEq(pool.balanceOf(investor), 1000 * 10 ** 18);
        assertEq(pool.totalPoolValue(), 1000 * 10 ** 18);
        assertEq(stablecoin.balanceOf(address(pool)), 1000 * 10 ** 18);
    }

    function testWithdraw() public {
        vm.startPrank(investor);
        pool.deposit(1000 * 10 ** 18);
        pool.withdraw(500 * 10 ** 18);
        vm.stopPrank();

        assertEq(pool.balanceOf(investor), 500 * 10 ** 18);
        assertEq(pool.totalPoolValue(), 500 * 10 ** 18);
    }
}
