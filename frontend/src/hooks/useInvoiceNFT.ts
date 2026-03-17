import { useReadContract, useWriteContract } from "wagmi";
import { CONTRACT_ADDRESSES, ABIS } from "@/config/contracts";

export function useInvoiceDetails(tokenId: bigint | undefined) {
  return useReadContract({
    address: CONTRACT_ADDRESSES.invoiceNFT,
    abi: ABIS.invoiceNFT,
    functionName: "invoices",
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  });
}

export function useMintInvoice() {
  const { writeContract, ...rest } = useWriteContract();

  const mint = (business: `0x${string}`, uri: string, faceValue: bigint, advanceAmount: bigint, dueDate: bigint) => {
    writeContract({
      address: CONTRACT_ADDRESSES.invoiceNFT,
      abi: ABIS.invoiceNFT,
      functionName: "mintInvoice",
      args: [business, uri, faceValue, advanceAmount, dueDate],
    });
  };

  return { mint, ...rest };
}
