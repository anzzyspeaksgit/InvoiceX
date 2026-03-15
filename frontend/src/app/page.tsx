import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-gradient-to-b from-gray-50 to-gray-200">
      <div className="z-10 w-full max-w-5xl items-center justify-between font-mono text-sm lg:flex">
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
          InvoiceX
        </h1>
        <p className="mt-4 text-xl text-gray-600">
          Decentralized Invoice Factoring on BNB Chain
        </p>
        
        <div className="mt-10 flex gap-x-6">
          <Link href="/business">
            <Button size="lg" className="bg-blue-600 hover:bg-blue-500 text-white">
              Business Portal
            </Button>
          </Link>
          <Link href="/invest">
            <Button size="lg" variant="outline" className="border-gray-400 text-gray-900">
              Investor Dashboard
            </Button>
          </Link>
        </div>
      </div>
    </main>
  );
}
