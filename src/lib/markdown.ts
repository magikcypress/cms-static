import matter from 'gray-matter'
import { remark } from 'remark'
import remarkHtml from 'remark-html'
import remarkGfm from 'remark-gfm'
import slugify from 'slugify'
import { getFile, listFiles } from './github'

export interface PostMeta {
  slug: string; title: string; date: string; excerpt: string
  tags: string[]; status: 'draft' | 'published'; author?: string
}
export interface Post extends PostMeta { content: string; contentHtml?: string }

export function parseMarkdown(raw: string, slug: string): Post {
  const { data, content } = matter(raw)
  return {
    slug,
    title: data.title ?? 'Sans titre',
    date: data.date ?? new Date().toISOString().split('T')[0],
    excerpt: data.excerpt ?? '',
    tags: Array.isArray(data.tags) ? data.tags : [],
    status: data.status ?? 'draft',
    author: data.author ?? '',
    content,
  }
}

export function serializeMarkdown(post: Omit<Post, 'contentHtml'>): string {
  const tags = JSON.stringify(post.tags)
  return [
    '---',
    `title: "${post.title}"`,
    `date: "${post.date}"`,
    `excerpt: "${post.excerpt}"`,
    `tags: ${tags}`,
    `status: "${post.status}"`,
    `author: "${post.author ?? ''}"`,
    '---',
    '',
    post.content,
  ].join('\n')
}

export async function markdownToHtml(markdown: string): Promise<string> {
  const result = await remark().use(remarkGfm).use(remarkHtml, { sanitize: false }).process(markdown)
  return result.toString()
}

export function makeSlug(title: string): string {
  return slugify(title, { lower: true, strict: true, locale: 'fr' })
}

export async function getAllPosts(): Promise<PostMeta[]> {
  const files = await listFiles('content/posts')
  const posts = await Promise.all(files.map(async (f: { name: string }) => {
    const slug = f.name.replace('.md', '')
    const file = await getFile(`content/posts/${f.name}`)
    if (!file) return null
    return parseMarkdown(file.content, slug) as PostMeta
  }))
  return posts.filter(Boolean).sort((a, b) => new Date(b!.date).getTime() - new Date(a!.date).getTime()) as PostMeta[]
}

export async function getPostBySlug(slug: string): Promise<Post | null> {
  const file = await getFile(`content/posts/${slug}.md`)
  if (!file) return null
  const post = parseMarkdown(file.content, slug)
  post.contentHtml = await markdownToHtml(post.content)
  return post
}
