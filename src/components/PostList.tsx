import { PostMeta } from '@/lib/markdown'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
interface PostListProps { posts: PostMeta[]; showStatus?: boolean; showActions?: boolean }
export function PostList({ posts, showStatus = false, showActions = false }: PostListProps) {
  if (posts.length === 0) return (
    <div className="text-center py-16 text-muted-foreground">
      <p className="text-lg">Aucun article pour l&apos;instant.</p>
      {showActions && <a href="/admin/edit/new" className="mt-4 inline-block px-4 py-2 bg-primary text-primary-foreground rounded-md text-sm hover:opacity-90">Créer le premier article</a>}
    </div>
  )
  return (
    <div className="space-y-6">
      {posts.map((post) => (
        <article key={post.slug} className="group border border-border rounded-xl p-6 hover:border-primary/50 transition-colors bg-card">
          <div className="flex items-start justify-between gap-4">
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-2 flex-wrap">
                <time className="text-sm text-muted-foreground">{format(new Date(post.date), 'd MMMM yyyy', { locale: fr })}</time>
                {showStatus && <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${post.status === 'published' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>{post.status === 'published' ? 'Publié' : 'Brouillon'}</span>}
                {post.tags.slice(0, 3).map((tag) => <span key={tag} className="text-xs px-2 py-0.5 rounded-full bg-muted text-muted-foreground">{tag}</span>)}
              </div>
              <h2 className="text-xl font-semibold mb-2 group-hover:text-primary transition-colors">
                <a href={showActions ? `/admin/edit/${post.slug}` : `/posts/${post.slug}`}>{post.title}</a>
              </h2>
              {post.excerpt && <p className="text-muted-foreground text-sm leading-relaxed line-clamp-2">{post.excerpt}</p>}
            </div>
            {showActions && (
              <div className="flex items-center gap-2 shrink-0">
                <a href={`/posts/${post.slug}`} target="_blank" className="text-xs px-3 py-1.5 rounded border border-border hover:bg-muted transition-colors">Voir</a>
                <a href={`/admin/edit/${post.slug}`} className="text-xs px-3 py-1.5 rounded bg-primary text-primary-foreground hover:opacity-90 transition-opacity">Éditer</a>
              </div>
            )}
          </div>
        </article>
      ))}
    </div>
  )
}
