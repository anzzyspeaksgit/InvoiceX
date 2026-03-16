# InvoiceX Architecture

## Overview
InvoiceX is a decentralized invoice factoring platform built on the BNB Chain. It enables businesses to tokenize their accounts receivable into NFTs and obtain immediate liquidity either by selling them directly on a secondary marketplace or by drawing instant liquidity from a pooled factoring fund.

## Smart Contracts Architecture

The smart contract system relies on four primary components interacting with a base token architecture:

### 1. InvoiceNFT (ERC721)
- **Standard**: `ERC721URIStorage`, `AccessControl`
- **Purpose**: Represents individual real-world business invoices. 
- **Metadata**: Points to an IPFS JSON file containing business details, invoice hash, due dates, and terms.
- **On-chain State**: Tracks `faceValue` (total amount due), `advanceAmount` (discounted payout to the business), `dueDate`, and `status` (`Listed`, `Financed`, `Repaid`, `Defaulted`).
- **Access**: Only authorized minters (or the Factoring Pool) can update the state to prevent tampering.

### 2. FactoringPool (ERC20 / BaseRWA)
- **Standard**: Inherits `BaseRWA` (custom shared RWA token schema).
- **Purpose**: A pooled liquidity fund where retail and institutional investors deposit stablecoins to receive `INVX-POOL` shares.
- **Yield Generation**: The pool uses deposited stablecoins to purchase invoices at a discount (the `advanceAmount`). When the payer settles the invoice at the `faceValue`, the difference becomes yield.
- **NAV Calculation**: The Net Asset Value linearly accounts for cash-on-hand and expected returns, allowing shares to appreciate natively without rebasing.

### 3. InvoiceMarketplace
- **Purpose**: A peer-to-peer secondary market for individual invoice trading.
- **Mechanics**: Businesses can list their `InvoiceNFT` for a specific stablecoin price. Buyers can purchase the invoice directly, bypassing the pool for immediate high-yield, high-risk isolated exposure.

### 4. PaymentSettlement
- **Purpose**: A routing contract handling the final repayment of invoices by the buyers/payers.
- **Mechanics**: Pulls stablecoins from the payer and routes the funds directly to the *current* owner of the `InvoiceNFT` (whether that is a private wallet who bought it on the Marketplace, or the `FactoringPool`).

## Yield Calculations

When a business requests factoring, they agree to an advance rate (e.g., 90%). 
- **Face Value**: $10,000
- **Advance Amount**: $9,000
- **Duration**: 30 Days
- **Gross Yield**: $1,000 (11.11% isolated return over 30 days)

Upon settlement, the $1,000 yield is instantly realized in the `FactoringPool`, augmenting `totalPoolValue` and proportionately increasing the redemption value of all circulating `INVX-POOL` shares based on the standard `getAssetPrice()` mechanism from `BaseRWA`.
