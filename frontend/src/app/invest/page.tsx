import { Button } from "@/components/ui/button";
import Link from "next/link";

export default function InvestorDashboard() {
  return (
    <div className="container mx-auto p-8">
      <header className="flex justify-between items-center mb-10">
        <h1 className="text-3xl font-bold">Investor Portal</h1>
        <div className="space-x-4">
          <Link href="/">
            <Button variant="outline">Back Home</Button>
          </Link>
        </div>
      </header>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">My INVX-POOL Balance</h3>
          <p className="text-3xl font-bold mt-2">0.00</p>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">Current NAV Price</h3>
          <p className="text-3xl font-bold mt-2">$1.00</p>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm border border-gray-100">
          <h3 className="text-gray-500 text-sm font-medium">Total Yield Earned</h3>
          <p className="text-3xl font-bold mt-2">$0.00</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div>
          <h2 className="text-xl font-semibold mb-4">Factoring Pool</h2>
          <div className="bg-white rounded-lg shadow-sm border border-gray-100 p-8 text-center">
            <p className="text-gray-500 mb-6">Deposit stablecoins into the factoring pool to earn yield automatically as invoices are financed and repaid.</p>
            <Button variant="default" className="w-full sm:w-auto">Deposit to Pool</Button>
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
