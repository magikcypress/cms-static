import type { MetadataRoute } from 'next'
import { getAllPosts } from '@/lib/markdown'

export const revalidate = 3600

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? ''
  const posts = await getAllPosts()
  const published = posts.filter((p) => p.status === 'published')

  const postEntries: MetadataRoute.Sitemap = published.map((post) => ({
    url: `${siteUrl}/posts/${post.slug}`,
    lastModified: new Date(post.date),
    changeFrequency: 'monthly',
    priority: 0.8,
  }))

  return [
    { url: siteUrl, lastModified: new Date(), changeFrequency: 'daily', priority: 1 },
    ...postEntries,
  ]
}
