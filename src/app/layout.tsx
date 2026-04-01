import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
const inter = Inter({ subsets: ['latin'] })
const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL ?? 'https://cms-gws6mq9ck-magikcypress-projects.vercel.app'
export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: { default: 'Mon Blog', template: '%s — Mon Blog' },
  description: 'Articles et réflexions sur le développement web.',
  openGraph: {
    type: 'website',
    locale: 'fr_FR',
    siteName: 'Mon Blog',
    url: SITE_URL,
  },
  twitter: { card: 'summary_large_image' },
  robots: { index: true, follow: true },
}
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
