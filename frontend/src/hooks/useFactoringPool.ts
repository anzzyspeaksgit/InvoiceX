import { useReadContract, useWriteContract, useWatchContractEvent } from "wagmi";
import { CONTRACT_ADDRESSES, ABIS } from "@/config/contracts";

export function useFactoringPoolInfo() {
  return useReadContract({
    address: CONTRACT_ADDRESSES.factoringPool,
    abi: ABIS.factoringPool,
    functionName: "totalPoolValue",
  });
}

export function useFactoringPoolShares(address?: `0x${string}`) {
  return useReadContract({
    address: CONTRACT_ADDRESSES.factoringPool,
    abi: ABIS.factoringPool,
    functionName: "balanceOf",
    args: address ? [address] : undefined,
    query: { enabled: !!address },
  });
}

export function useDepositPool() {
  const { writeContract, ...rest } = useWriteContract();

  const deposit = (amountWei: bigint) => {
    writeContract({
      address: CONTRACT_ADDRESSES.factoringPool,
      abi: ABIS.factoringPool,
      functionName: "deposit",
      args: [amountWei],
    });
  };

  return { deposit, ...rest };
}
