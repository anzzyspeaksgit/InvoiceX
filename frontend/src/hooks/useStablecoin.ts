import { useReadContract, useWriteContract } from "wagmi";
import { CONTRACT_ADDRESSES } from "@/config/contracts";
import { erc20Abi } from "viem";

export function useStablecoinBalance(address?: `0x${string}`) {
  return useReadContract({
    address: CONTRACT_ADDRESSES.stablecoin,
    abi: erc20Abi,
    functionName: "balanceOf",
    args: address ? [address] : undefined,
    query: { enabled: !!address },
  });
}

export function useStablecoinAllowance(owner?: `0x${string}`, spender?: `0x${string}`) {
  return useReadContract({
    address: CONTRACT_ADDRESSES.stablecoin,
    abi: erc20Abi,
    functionName: "allowance",
    args: owner && spender ? [owner, spender] : undefined,
    query: { enabled: !!owner && !!spender },
  });
}

export function useApproveStablecoin() {
  const { writeContract, ...rest } = useWriteContract();

  const approve = (spender: `0x${string}`, amount: bigint) => {
    writeContract({
      address: CONTRACT_ADDRESSES.stablecoin,
      abi: erc20Abi,
      functionName: "approve",
      args: [spender, amount],
    });
  };

  return { approve, ...rest };
}
