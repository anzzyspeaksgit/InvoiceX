"use client";

import { Button } from "@/components/ui/button";
import Link from "next/link";
import { useAccount } from "wagmi";
import { useFactoringPoolShares, useFactoringPoolInfo, useDepositPool } from "@/hooks/useFactoringPool";
import { useStablecoinBalance, useStablecoinAllowance, useApproveStablecoin } from "@/hooks/useStablecoin";
import { useState } from "react";
import { parseUnits, formatUnits } from "viem";
import { CONTRACT_ADDRESSES } from "@/config/contracts";

export default function InvestorDashboard() {
  const { address, isConnected } = useAccount();
  const { data: poolShares } = useFactoringPoolShares(address);
  const { data: totalPoolValue } = useFactoringPoolInfo();
  
  const { data: stableBalance } = useStablecoinBalance(address);
  const { data: allowance } = useStablecoinAllowance(address, CONTRACT_ADDRESSES.factoringPool);
  
  const { approve, isPending: isApproving } = useApproveStablecoin();
  const { deposit, isPending: isDepositing } = useDepositPool();

  const [depositAmount, setDepositAmount] = useState("");

  const handleDeposit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!depositAmount || !address) return;

    const amountWei = parseUnits(depositAmount, 18);
    
    // Check if allowance is sufficient
    if (allowance !== undefined && allowance < amountWei) {
      approve(CONTRACT_ADDRESSES.factoringPool, amountWei);
      return;
    }
    
    deposit(amountWei);
  };

  return (
    <div className="container mx-auto p-8">
      <header className="flex justify-between items-center mb-10">
        <div>
          <h1 className="text-3xl font-bold">Investor Portal</h1>
          {isConnected ? (
            <p className="text-sm text-gray-500 mt-1">Connected: {address}</p>
          ) : (
            <p className="text-sm text-red-500 mt-1">Please connect your wallet</p>
          )}
        </div>
        <div className="space-x-4">
          <Link href="/">
            <Button variant="outline">Back Home</Button>
          </Link>
        </div>
      </header>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">My INVX-POOL Balance</h3>
          <p className="text-3xl font-bold mt-2">
            {poolShares ? Number(formatUnits(poolShares as bigint, 18)).toLocaleString(undefined, { maximumFractionDigits: 2 }) : "0.00"}
          </p>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">Global Pool Liquidity</h3>
          <p className="text-3xl font-bold mt-2">
             {totalPoolValue ? `$${Number(formatUnits(totalPoolValue as bigint, 18)).toLocaleString(undefined, { maximumFractionDigits: 2 })}` : "$0.00"}
          </p>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">Stablecoin Wallet Balance</h3>
          <p className="text-3xl font-bold mt-2">
            {stableBalance ? `$${Number(formatUnits(stableBalance as bigint, 18)).toLocaleString(undefined, { maximumFractionDigits: 2 })}` : "$0.00"}
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div>
          <h2 className="text-xl font-semibold mb-4">Factoring Pool</h2>
          <div className="bg-white rounded-lg shadow-sm border border-gray-100 p-8 text-center">
            <p className="text-gray-500 mb-6">Deposit stablecoins into the factoring pool to earn yield automatically as invoices are financed and repaid.</p>
            
            <form onSubmit={handleDeposit} className="flex flex-col space-y-4 max-w-xs mx-auto">
              <div className="relative rounded-md shadow-sm">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <span className="text-gray-500 sm:text-sm">$</span>
                </div>
                <input
                  type="number"
                  value={depositAmount}
                  onChange={(e) => setDepositAmount(e.target.value)}
                  className="focus:ring-blue-500 focus:border-blue-500 block w-full pl-7 pr-12 sm:text-sm border-gray-300 rounded-md py-2 border"
                  placeholder="0.00"
                  required
                />
              </div>
              <Button type="submit" disabled={!isConnected || isApproving || isDepositing}>
                {isApproving ? "Approving..." : isDepositing ? "Depositing..." : "Deposit to Pool"}
              </Button>
            </form>
          </div>
        </div>

        <div>
          <h2 className="text-xl font-semibold mb-4">Secondary Marketplace</h2>
          <div className="bg-white rounded-lg shadow-sm border border-gray-100 p-8 text-center">
            <p className="text-gray-500 mb-6">Purchase individual high-yield invoice NFTs directly from businesses looking for immediate liquidity.</p>
            <Link href="/invest/marketplace">
              <Button variant="outline" className="w-full sm:w-auto">Browse Marketplace</Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
