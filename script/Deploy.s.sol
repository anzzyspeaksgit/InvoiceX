// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/InvoiceNFT.sol";
import "../contracts/FactoringPool.sol";
import "../contracts/InvoiceMarketplace.sol";
import "../contracts/PaymentSettlement.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockStablecoinDeploy is ERC20 {
    constructor() ERC20("Mock USD", "mUSD") {
        _mint(msg.sender, 10000000 * 10 ** 18);
    }
}

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Mock Stablecoin (for Testnet)
        MockStablecoinDeploy stablecoin = new MockStablecoinDeploy();
        console.log("MockStablecoin deployed at:", address(stablecoin));

        // 2. Deploy Invoice NFT
        InvoiceNFT invoiceNFT = new InvoiceNFT();
        console.log("InvoiceNFT deployed at:", address(invoiceNFT));

        // 3. Deploy Factoring Pool
        FactoringPool pool = new FactoringPool(address(stablecoin), address(invoiceNFT));
        console.log("FactoringPool deployed at:", address(pool));

        // 4. Deploy Invoice Marketplace
        InvoiceMarketplace marketplace = new InvoiceMarketplace(address(invoiceNFT), address(stablecoin));
        console.log("InvoiceMarketplace deployed at:", address(marketplace));

        // 5. Deploy Payment Settlement
        PaymentSettlement settlement = new PaymentSettlement(address(invoiceNFT), address(stablecoin));
        console.log("PaymentSettlement deployed at:", address(settlement));

        // Setup Initial Roles and Permissions
        invoiceNFT.grantRole(invoiceNFT.MINTER_ROLE(), address(pool));

        vm.stopBroadcast();
    }
}
