import type { Metadata } from 'next'
import { getPostBySlug, getAllPosts } from '@/lib/markdown'
import { Renderer } from '@/components/Renderer'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import { notFound } from 'next/navigation'

export const revalidate = 60

export async function generateStaticParams() {
  const posts = await getAllPosts()
  return posts.filter((p) => p.status === 'published').map((p) => ({ slug: p.slug }))
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params
  const post = await getPostBySlug(slug)
  if (!post) return {}
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? ''
  const url = `${siteUrl}/posts/${slug}`
  return {
    title: post.title,
    description: post.excerpt || post.title,
    authors: post.author ? [{ name: post.author }] : undefined,
    keywords: post.tags,
    alternates: { canonical: url },
    openGraph: {
      type: 'article',
      url,
      title: post.title,
      description: post.excerpt || post.title,
      publishedTime: post.date,
      authors: post.author ? [post.author] : undefined,
      tags: post.tags,
    },
    twitter: {
      card: 'summary_large_image',
      title: post.title,
      description: post.excerpt || post.title,
    },
  }
}

export default async function PostPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const post = await getPostBySlug(slug)
  if (!post || post.status !== 'published') notFound()

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? ''
  // JSON-LD : JSON.stringify échappe tous les caractères spéciaux — pas de risque XSS
  const jsonLd = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'BlogPosting',
    headline: post.title,
    description: post.excerpt,
    datePublished: post.date,
    author: post.author ? { '@type': 'Person', name: post.author } : undefined,
    keywords: post.tags?.join(', '),
    url: `${siteUrl}/posts/${slug}`,
  })

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLd }} />
      <div className="max-w-3xl mx-auto px-4 py-12">
        <a href="/" className="text-sm text-muted-foreground hover:text-foreground transition-colors mb-8 inline-block">← Retour</a>
        <header className="mb-10">
          <div className="flex items-center gap-3 mb-4 flex-wrap">
            <time dateTime={post.date} className="text-sm text-muted-foreground">{format(new Date(post.date), 'd MMMM yyyy', { locale: fr })}</time>
            {post.author && <span className="text-sm text-muted-foreground">par {post.author}</span>}
            {post.tags.map((tag) => <span key={tag} className="text-xs px-2 py-0.5 rounded-full bg-muted text-muted-foreground">{tag}</span>)}
          </div>
          <h1 className="text-4xl font-bold tracking-tight mb-4">{post.title}</h1>
          {post.excerpt && <p className="text-xl text-muted-foreground leading-relaxed">{post.excerpt}</p>}
        </header>
        <hr className="border-border mb-10" />
        <Renderer html={post.contentHtml ?? ''} />
      </div>
    </>
  )
}
