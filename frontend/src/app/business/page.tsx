"use client";

import { Button } from "@/components/ui/button";
import Link from "next/link";
import { useAccount } from "wagmi";
import { useFactoringPoolInfo } from "@/hooks/useFactoringPool";

export default function BusinessDashboard() {
  const { address, isConnected } = useAccount();
  const { data: totalPoolValue } = useFactoringPoolInfo();

  return (
    <div className="container mx-auto p-8">
      <header className="flex justify-between items-center mb-10">
        <div>
          <h1 className="text-3xl font-bold">Business Portal</h1>
          {isConnected ? (
            <p className="text-sm text-gray-500 mt-1">Connected: {address}</p>
          ) : (
            <p className="text-sm text-red-500 mt-1">Please connect your wallet</p>
          )}
        </div>
        <div className="space-x-4">
          <Link href="/business/create">
            <Button disabled={!isConnected}>+ Tokenize New Invoice</Button>
          </Link>
          <Link href="/">
            <Button variant="outline">Back Home</Button>
          </Link>
        </div>
      </header>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">Total Factored (All Time)</h3>
          <p className="text-3xl font-bold mt-2">$0.00</p>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">Global Factoring Pool Liquidity</h3>
          <p className="text-3xl font-bold mt-2">
            {totalPoolValue ? `$${(Number(totalPoolValue) / 1e18).toLocaleString()}` : "$0.00"}
          </p>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">Active Invoices</h3>
          <p className="text-3xl font-bold mt-2">0</p>
        </div>
      </div>

      <h2 className="text-xl font-semibold mb-4">My Invoices</h2>
      <div className="bg-white rounded-lg shadow-sm border border-gray-100 p-8 text-center">
        {isConnected ? (
           <>
            <p className="text-gray-500">No invoices tokenized yet. Start by creating your first invoice NFT.</p>
            <Link href="/business/create">
              <Button className="mt-4" variant="outline">Create Invoice</Button>
            </Link>
           </>
        ) : (
          <p className="text-gray-500">Connect your wallet to view and manage your tokenized invoices.</p>
        )}
      </div>
    </div>
  );
}
