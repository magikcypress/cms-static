import { getAllPosts } from '@/lib/markdown'
import { PostList } from '@/components/PostList'
export const revalidate = 0
export default async function AdminPage() {
  const posts = await getAllPosts()
  const published = posts.filter((p) => p.status === 'published').length
  const drafts = posts.filter((p) => p.status === 'draft').length
  return (
    <div className="max-w-5xl mx-auto px-4 py-10">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
          <p className="text-muted-foreground mt-1">{posts.length} article{posts.length !== 1 ? 's' : ''} au total</p>
        </div>
        <a href="/admin/edit/new" className="px-5 py-2.5 rounded-lg bg-primary text-primary-foreground font-medium hover:opacity-90 transition-opacity">+ Nouvel article</a>
      </div>
      <div className="grid grid-cols-3 gap-4 mb-10">
        {[{ label: 'Total', value: posts.length, color: 'text-foreground' }, { label: 'Publiés', value: published, color: 'text-green-600' }, { label: 'Brouillons', value: drafts, color: 'text-yellow-600' }].map(({ label, value, color }) => (
          <div key={label} className="border border-border rounded-xl p-5 bg-card">
            <p className="text-sm text-muted-foreground">{label}</p>
            <p className={`text-3xl font-bold mt-1 ${color}`}>{value}</p>
          </div>
        ))}
      </div>
      <PostList posts={posts} showStatus showActions />
    </div>
  )
}
