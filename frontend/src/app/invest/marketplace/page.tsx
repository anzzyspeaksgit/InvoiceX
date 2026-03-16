import { Button } from "@/components/ui/button";
import Link from "next/link";

export default function Marketplace() {
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

      <div className="mb-8">
        <p className="text-gray-600">Purchase individual invoice NFTs directly from businesses. Earn yield by collecting the face value on the due date.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Placeholder cards for now */}
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="flex justify-between items-center mb-4">
            <span className="bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded">Active</span>
            <span className="text-sm text-gray-500">ID #1</span>
          </div>
          <div className="mb-4">
            <p className="text-sm text-gray-500">Face Value</p>
            <p className="text-2xl font-bold text-gray-900">$10,000.00</p>
          </div>
          <div className="mb-4">
            <p className="text-sm text-gray-500">Asking Price</p>
            <p className="text-xl font-bold text-green-600">$9,000.00</p>
          </div>
          <div className="mb-6">
            <p className="text-sm text-gray-500">Expected Yield</p>
            <p className="text-sm font-semibold text-gray-900">11.11% in 30 days</p>
          </div>
          <Button className="w-full">Buy Invoice</Button>
        </div>
        
        {/* If empty */}
        <div className="p-6 col-span-full text-center border-2 border-dashed border-gray-300 rounded-lg">
          <p className="text-gray-500 mb-2">No active listings.</p>
          <p className="text-sm text-gray-400">Check back later when businesses tokenize their accounts receivable.</p>
        </div>
      </div>
    </div>
  );
}
