import { getAllPosts } from '@/lib/markdown'
import { PostList } from '@/components/PostList'
export const revalidate = 60
export default async function HomePage() {
  const posts = await getAllPosts()
  const published = posts.filter((p) => p.status === 'published')
  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-2 tracking-tight">Blog</h1>
      <p className="text-muted-foreground mb-10">{published.length} article{published.length !== 1 ? 's' : ''} publié{published.length !== 1 ? 's' : ''}</p>
      <PostList posts={published} />
    </div>
  )
}
