import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
const inter = Inter({ subsets: ['latin'] })
export const metadata: Metadata = { title: 'Mon CMS', description: 'CMS Next.js + TipTap + GitHub' }
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <nav className="border-b border-border bg-card">
          <div className="max-w-5xl mx-auto px-4 h-14 flex items-center justify-between">
            <a href="/" className="font-semibold text-lg tracking-tight hover:text-primary transition-colors">📝 Mon CMS</a>
            <a href="/admin" className="text-sm px-4 py-2 rounded-md bg-primary text-primary-foreground hover:opacity-90 transition-opacity">Admin</a>
          </div>
        </nav>
        <main>{children}</main>
      </body>
    </html>
  )
}
