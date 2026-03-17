export const CONTRACT_ADDRESSES = {
  invoiceNFT: (process.env.NEXT_PUBLIC_INVOICE_NFT_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
  factoringPool: (process.env.NEXT_PUBLIC_FACTORING_POOL_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
  marketplace: (process.env.NEXT_PUBLIC_MARKETPLACE_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
  paymentSettlement: (process.env.NEXT_PUBLIC_PAYMENT_SETTLEMENT_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
  stablecoin: (process.env.NEXT_PUBLIC_STABLECOIN_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
};

import InvoiceNFTABI from "@/abi/InvoiceNFT.json";
import FactoringPoolABI from "@/abi/FactoringPool.json";
import InvoiceMarketplaceABI from "@/abi/InvoiceMarketplace.json";
import PaymentSettlementABI from "@/abi/PaymentSettlement.json";

export const ABIS = {
  invoiceNFT: InvoiceNFTABI as any,
  factoringPool: FactoringPoolABI as any,
  marketplace: InvoiceMarketplaceABI as any,
  paymentSettlement: PaymentSettlementABI as any,
};
