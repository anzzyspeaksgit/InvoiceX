# 📄 InvoiceX

**Decentralized Invoice Factoring on BNB Chain.** 

Built for the [RWA Demo Day Hackathon](https://dorahacks.io/hackathon/rwademoday/detail) to solve real-world liquidity crunches for small businesses by tokenizing accounts receivable into high-yield, short-term fractional assets.

---

## 🎯 The Problem & Solution
Businesses often wait 30, 60, or 90 days for clients to pay their invoices, resulting in severe cash flow bottlenecks. **InvoiceX** allows these businesses to tokenize their invoices as `ERC721` NFTs and immediately sell them at a slight discount (e.g., 90% of face value) to investors or our automated **Factoring Pool**. Investors earn the remaining yield (10%) when the invoice matures and is repaid.

## ✨ Core Features
1. **Invoice NFTs**: `ERC721` tokens representing individual invoices with associated `faceValue`, `advanceAmount`, and `dueDate`.
2. **Factoring Pool**: An automated, fractionalized liquidity pool where investors can deposit stablecoins to receive `INVX-POOL` yield-bearing shares.
3. **Secondary Marketplace**: A peer-to-peer marketplace for businesses to list their invoices and sell them directly to high-yield seekers.
4. **Payment Settlement**: A secure routing contract that ensures the final invoice payment is distributed to the *current* NFT holder.

## 🛠 Tech Stack

- **Smart Contracts**: Solidity `^0.8.20`, Foundry, OpenZeppelin v5
- **Frontend**: Next.js 14 (App Router), TailwindCSS, shadcn/ui
- **Web3**: RainbowKit, wagmi, viem
- **Network**: BNB Chain Testnet (Chain ID: `97`)

---

## 🚀 Getting Started

### 1. Smart Contracts
The `InvoiceX` protocol uses Foundry for compilation, testing, and deployment.

```bash
# Clean and build the contracts
make all

# Run test suite with gas reports
make coverage
```

To deploy to the BNB Testnet:
```bash
make deploy-testnet
```

### 2. Frontend
The frontend is a fully integrated Next.js application that reads directly from the exported smart contract ABIs.

```bash
# Navigate to the frontend directory
cd frontend

# Install dependencies
npm install

# Start the development server
npm run dev
```

Navigate to `http://localhost:3000` to interact with the Business Portal and Investor Dashboard.

---

## 📚 Architecture
Read the full system architecture and yield calculation math in [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md).

## 📄 License
MIT
