import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function Home() {
  return (
    <div className="flex flex-col items-center justify-center min-h-[80vh] px-4">
      <div className="text-center max-w-3xl">
        <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight text-gray-900 mb-6">
          Liquidate Your <span className="text-blue-600">Invoices.</span>
        </h1>
        <p className="text-xl md:text-2xl text-gray-600 mb-10 leading-relaxed">
          Tokenize your accounts receivable into fractional NFTs. Get paid instantly via the Factoring Pool or trade directly on the Secondary Marketplace.
        </p>
        
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link href="/business">
            <Button size="lg" className="w-full sm:w-auto text-lg px-8 py-6">
              I'm a Business
            </Button>
          </Link>
          <Link href="/invest">
            <Button size="lg" variant="outline" className="w-full sm:w-auto text-lg px-8 py-6">
              I'm an Investor
            </Button>
          </Link>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-24 w-full max-w-5xl">
        <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 flex flex-col items-center text-center">
          <div className="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mb-4 text-xl font-bold">1</div>
          <h3 className="text-xl font-bold mb-2">Tokenize</h3>
          <p className="text-gray-500">Mint your unpaid invoices as secure ERC721 NFTs on the BNB Chain.</p>
        </div>
        <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 flex flex-col items-center text-center">
          <div className="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mb-4 text-xl font-bold">2</div>
          <h3 className="text-xl font-bold mb-2">Liquidity</h3>
          <p className="text-gray-500">Draw an immediate 90% advance from the Factoring Pool.</p>
        </div>
        <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 flex flex-col items-center text-center">
          <div className="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mb-4 text-xl font-bold">3</div>
          <h3 className="text-xl font-bold mb-2">Yield</h3>
          <p className="text-gray-500">Investors earn the spread when the invoice is paid at face value.</p>
        </div>
      </div>
    </div>
  );
}
