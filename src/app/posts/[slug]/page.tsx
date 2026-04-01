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
export default async function PostPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const post = await getPostBySlug(slug)
  if (!post || post.status !== 'published') notFound()
  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <a href="/" className="text-sm text-muted-foreground hover:text-foreground transition-colors mb-8 inline-block">← Retour</a>
      <header className="mb-10">
        <div className="flex items-center gap-3 mb-4 flex-wrap">
          <time className="text-sm text-muted-foreground">{format(new Date(post.date), 'd MMMM yyyy', { locale: fr })}</time>
          {post.author && <span className="text-sm text-muted-foreground">par {post.author}</span>}
          {post.tags.map((tag) => <span key={tag} className="text-xs px-2 py-0.5 rounded-full bg-muted text-muted-foreground">{tag}</span>)}
        </div>
        <h1 className="text-4xl font-bold tracking-tight mb-4">{post.title}</h1>
        {post.excerpt && <p className="text-xl text-muted-foreground leading-relaxed">{post.excerpt}</p>}
      </header>
      <hr className="border-border mb-10" />
      <Renderer html={post.contentHtml ?? ''} />
    </div>
  )
}
