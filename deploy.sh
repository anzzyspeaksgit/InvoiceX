#!/bin/bash
set -e

PRIVATE_KEY=$(jq -r '.privateKey' ~/rwa-hackathon/shared/wallet.json)
RPC_URL=$(jq -r '.rpcUrl' ~/rwa-hackathon/shared/wallet.json)

echo "Deploying InvoiceX Contracts to BNB Testnet..."

forge script script/Deploy.s.sol:Deploy --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $BSCSCAN_API_KEY -vvvv
