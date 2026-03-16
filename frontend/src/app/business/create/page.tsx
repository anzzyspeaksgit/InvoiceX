"use client";

import { Button } from "@/components/ui/button";
import Link from "next/link";
import { useState } from "react";

export default function CreateInvoice() {
  const [amount, setAmount] = useState("");
  const [advance, setAdvance] = useState("");
  const [dueDate, setDueDate] = useState("");

  const handleMint = (e: React.FormEvent) => {
    e.preventDefault();
    alert("Smart contract integration pending. Face value: " + amount + ", Advance: " + advance);
  };

  return (
    <div className="max-w-xl mx-auto p-8 mt-10 bg-white rounded-lg shadow-sm border border-gray-100">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold">Tokenize New Invoice</h1>
        <Link href="/business">
          <Button variant="ghost" size="sm">Back</Button>
        </Link>
      </div>

      <form onSubmit={handleMint} className="space-y-6">
        <div>
          <label className="block text-sm font-medium text-gray-700">Face Value (Total amount due)</label>
          <div className="mt-1 relative rounded-md shadow-sm">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <span className="text-gray-500 sm:text-sm">$</span>
            </div>
            <input
              type="number"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="focus:ring-blue-500 focus:border-blue-500 block w-full pl-7 pr-12 sm:text-sm border-gray-300 rounded-md py-2 border"
              placeholder="0.00"
              required
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Advance Request (Discounted payout)</label>
          <p className="text-xs text-gray-500 mb-2">Typically 80-90% of Face Value</p>
          <div className="relative rounded-md shadow-sm">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <span className="text-gray-500 sm:text-sm">$</span>
            </div>
            <input
              type="number"
              value={advance}
              onChange={(e) => setAdvance(e.target.value)}
              className="focus:ring-blue-500 focus:border-blue-500 block w-full pl-7 pr-12 sm:text-sm border-gray-300 rounded-md py-2 border"
              placeholder="0.00"
              required
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Due Date</label>
          <input
            type="date"
            value={dueDate}
            onChange={(e) => setDueDate(e.target.value)}
            className="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border-gray-300 rounded-md py-2 px-3 border"
            required
          />
        </div>

        <Button type="submit" className="w-full">
          Tokenize & Request Liquidity
        </Button>
      </form>
    </div>
  );
}
