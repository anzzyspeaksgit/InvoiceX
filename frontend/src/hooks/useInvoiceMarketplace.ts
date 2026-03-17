import { useReadContract, useWriteContract } from "wagmi";
import { CONTRACT_ADDRESSES, ABIS } from "@/config/contracts";

export function useListing(invoiceId: bigint | undefined) {
  return useReadContract({
    address: CONTRACT_ADDRESSES.marketplace,
    abi: ABIS.marketplace,
    functionName: "listings",
    args: invoiceId !== undefined ? [invoiceId] : undefined,
    query: { enabled: invoiceId !== undefined },
  });
}

export function useBuyInvoice() {
  const { writeContract, ...rest } = useWriteContract();

  const buyInvoice = (invoiceId: bigint) => {
    writeContract({
      address: CONTRACT_ADDRESSES.marketplace,
      abi: ABIS.marketplace,
      functionName: "buyInvoice",
      args: [invoiceId],
    });
  };

  return { buyInvoice, ...rest };
}

export function useListInvoice() {
  const { writeContract, ...rest } = useWriteContract();

  const listInvoice = (invoiceId: bigint, price: bigint) => {
    writeContract({
      address: CONTRACT_ADDRESSES.marketplace,
      abi: ABIS.marketplace,
      functionName: "listInvoice",
      args: [invoiceId, price],
    });
  };

  return { listInvoice, ...rest };
}
