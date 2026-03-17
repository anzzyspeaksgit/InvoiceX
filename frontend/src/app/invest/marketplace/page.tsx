"use client";

import { Button } from "@/components/ui/button";
import Link from "next/link";
import { useState } from "react";
import { useAccount } from "wagmi";
import { useBuyInvoice, useListing } from "@/hooks/useInvoiceMarketplace";
import { useStablecoinAllowance, useApproveStablecoin } from "@/hooks/useStablecoin";
import { useInvoiceDetails } from "@/hooks/useInvoiceNFT";
import { CONTRACT_ADDRESSES } from "@/config/contracts";
import { formatUnits } from "viem";

// Demo component to render a single listing card by ID
function ListingCard({ id }: { id: bigint }) {
  const { data: listingData } = useListing(id);
  const { data: invoiceData } = useInvoiceDetails(id);
  const { address } = useAccount();

  const { data: allowance } = useStablecoinAllowance(address, CONTRACT_ADDRESSES.marketplace);
  const { approve, isPending: isApproving } = useApproveStablecoin();
  const { buyInvoice, isPending: isBuying } = useBuyInvoice();

  if (!listingData || !invoiceData) return null;

  // listingData: [invoiceId, seller, price, active]
  const [, seller, price, active] = listingData as [bigint, string, bigint, boolean];
  if (!active) return null;

  // invoiceData: [faceValue, advanceAmount, dueDate, status, business]
  const [faceValue, , dueDate, , ] = invoiceData as [bigint, bigint, bigint, number, string];

  const formattedPrice = Number(formatUnits(price, 18));
  const formattedFace = Number(formatUnits(faceValue, 18));
  const yieldPct = ((formattedFace - formattedPrice) / formattedPrice) * 100;
  
  const dueDays = Math.max(0, Math.ceil((Number(dueDate) * 1000 - Date.now()) / (1000 * 60 * 60 * 24)));

  const handleBuy = () => {
    if (allowance !== undefined && allowance < price) {
      approve(CONTRACT_ADDRESSES.marketplace, price);
      return;
    }
    buyInvoice(id);
  };

  return (
    <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-200">
      <div className="flex justify-between items-center mb-4">
        <span className="bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded">Active</span>
        <span className="text-sm text-gray-500">ID #{id.toString()}</span>
      </div>
      <div className="mb-4">
        <p className="text-sm text-gray-500">Face Value</p>
        <p className="text-2xl font-bold text-gray-900">${formattedFace.toLocaleString(undefined, { minimumFractionDigits: 2 })}</p>
      </div>
      <div className="mb-4">
        <p className="text-sm text-gray-500">Asking Price</p>
        <p className="text-xl font-bold text-green-600">${formattedPrice.toLocaleString(undefined, { minimumFractionDigits: 2 })}</p>
      </div>
      <div className="mb-6">
        <p className="text-sm text-gray-500">Expected Yield</p>
        <p className="text-sm font-semibold text-gray-900">{yieldPct.toFixed(2)}% in {dueDays} days</p>
      </div>
      <Button 
        className="w-full" 
        onClick={handleBuy} 
        disabled={isApproving || isBuying}
      >
        {isApproving ? "Approving..." : isBuying ? "Buying..." : "Buy Invoice"}
      </Button>
    </div>
  );
}

export default function Marketplace() {
  const [searchId, setSearchId] = useState("1");
  const { isConnected } = useAccount();

  return (
    <div className="container mx-auto p-8">
      <header className="flex justify-between items-center mb-10">
        <h1 className="text-3xl font-bold">Secondary Marketplace</h1>
        <div className="space-x-4">
          <Link href="/invest">
            <Button variant="outline">Back to Investor Portal</Button>
          </Link>
        </div>
      </header>

      <div className="mb-8 p-6 bg-white rounded-lg shadow-sm border border-gray-200">
        <p className="text-gray-600 mb-4">Purchase individual invoice NFTs directly from businesses. Earn yield by collecting the face value on the due date.</p>
        <div className="flex gap-4 max-w-sm">
          <input
            type="number"
            value={searchId}
            onChange={(e) => setSearchId(e.target.value)}
            className="focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md py-2 px-3 border"
            placeholder="Search by Invoice ID"
            min="1"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {isConnected && searchId ? (
          <ListingCard id={BigInt(searchId)} />
        ) : (
          <div className="p-6 col-span-full text-center border-2 border-dashed border-gray-300 rounded-lg">
            <p className="text-gray-500 mb-2">Please connect your wallet or search for a valid Invoice ID.</p>
          </div>
        )}
      </div>
    </div>
  );
}
