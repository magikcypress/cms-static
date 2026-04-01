import type { NextConfig } from 'next'
const nextConfig: NextConfig = {
  experimental: {
    serverComponentsExternalPackages: ['gray-matter'],
  },
}
export default nextConfig
