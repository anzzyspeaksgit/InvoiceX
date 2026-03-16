# InvoiceX Deployment Guide

## Prerequisites

1. **Foundry**: Ensure `forge` is installed and updated.
2. **Wallet**: A valid `wallet.json` located at `~/rwa-hackathon/shared/wallet.json` containing the `privateKey` and `rpcUrl` for the BNB Testnet.
3. **API Keys**: Make sure the `BSCSCAN_API_KEY` environment variable is set for contract verification.
4. **Testnet BNB**: The deployer wallet must be funded with tBNB from the BNB Smart Chain faucet.

## Deployment Steps

To deploy the entire InvoiceX smart contract suite to the BNB Testnet, simply run the automated bash script from the project root:

```bash
make deploy-testnet
# or
./deploy.sh
```

### What the Script Does:
1. Extracts the private key securely from the shared JSON wallet using `jq`.
2. Extracts the BNB Testnet RPC URL.
3. Executes `forge script script/Deploy.s.sol:Deploy --broadcast --verify`.
4. Deploys a mock stablecoin (`MockUSD`) for testnet interaction.
5. Deploys `InvoiceNFT`, `FactoringPool`, `InvoiceMarketplace`, and `PaymentSettlement`.
6. Wires the contracts together (e.g., granting `MINTER_ROLE` to the Factoring Pool so it can automatically update invoice statuses upon advancing funds).
7. Automatically submits the source code to BscScan for verification.

## Local Testing & Verification

Before deploying, always run the full test suite and gas reports:

```bash
make all
```

This will run `forge clean`, `forge build`, and `forge test -vvv`.

## Post-Deployment

After a successful deployment, the console will output the addresses for all 5 deployed contracts. 
1. Copy these addresses.
2. Update the frontend environment variables (`frontend/.env.local`).
3. The ABIs are automatically synchronized in `frontend/src/abi/` via our `jq` extraction script.

## Live Network Constraints
- The `FactoringPool` uses a custom Net Asset Value (NAV) implementation inheriting from `BaseRWA`.
- It dynamically updates the pool value when an invoice is fully repaid (Yield = `faceValue` - `advanceAmount`).
- The `InvoiceMarketplace` is fully permissionless for listing, assuming the user owns the corresponding `InvoiceNFT` and has approved the marketplace contract to transfer it.
