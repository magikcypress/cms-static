#!/bin/bash
# ============================================================
#  CMS Installer — Next.js + TipTap + Tailwind + GitHub API
#  Usage: bash install-cms.sh
# ============================================================
set -e

TARGET="$HOME/Documents/work/cms"
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║     CMS Next.js + TipTap + GitHub — Installer   ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "📁 Destination : $TARGET"
echo ""

mkdir -p "$TARGET"
mkdir -p "$TARGET/content/posts"
mkdir -p "$TARGET/content/pages"
mkdir -p "$TARGET/src/app/posts/[slug]"
mkdir -p "$TARGET/src/app/admin/edit/[slug]"
mkdir -p "$TARGET/src/app/api/posts"
mkdir -p "$TARGET/src/components"
mkdir -p "$TARGET/src/lib"
mkdir -p "$TARGET/public/uploads"

echo "📄 Génération des fichiers sources..."

# ── package.json ──────────────────────────────────────────────────
cat > "$TARGET/package.json" << 'HEREDOC'
{
  "name": "cms",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "15.2.4",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "@tiptap/react": "^2.11.5",
    "@tiptap/pm": "^2.11.5",
    "@tiptap/starter-kit": "^2.11.5",
    "@tiptap/extension-image": "^2.11.5",
    "@tiptap/extension-link": "^2.11.5",
    "@tiptap/extension-placeholder": "^2.11.5",
    "@tiptap/extension-underline": "^2.11.5",
    "@tiptap/extension-text-align": "^2.11.5",
    "@tiptap/extension-highlight": "^2.11.5",
    "gray-matter": "^4.0.3",
    "remark": "^15.0.1",
    "remark-html": "^16.0.1",
    "remark-gfm": "^4.0.1",
    "slugify": "^1.6.6",
    "date-fns": "^4.1.0",
    "lucide-react": "^0.511.0",
    "clsx": "^2.1.1",
    "tailwind-merge": "^3.3.0",
    "class-variance-authority": "^0.7.1"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "tailwindcss": "^3.4.1",
    "postcss": "^8",
    "autoprefixer": "^10.0.1",
    "eslint": "^9",
    "eslint-config-next": "15.2.4"
  }
}
HEREDOC

# ── tsconfig.json ─────────────────────────────────────────────────
cat > "$TARGET/tsconfig.json" << 'HEREDOC'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
HEREDOC

# ── next.config.ts ────────────────────────────────────────────────
cat > "$TARGET/next.config.ts" << 'HEREDOC'
import type { NextConfig } from 'next'
const nextConfig: NextConfig = {
  experimental: {
    serverComponentsExternalPackages: ['gray-matter'],
  },
}
export default nextConfig
HEREDOC

# ── tailwind.config.ts ────────────────────────────────────────────
cat > "$TARGET/tailwind.config.ts" << 'HEREDOC'
import type { Config } from 'tailwindcss'
const config: Config = {
  darkMode: ['class'],
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: { DEFAULT: 'hsl(var(--primary))', foreground: 'hsl(var(--primary-foreground))' },
        secondary: { DEFAULT: 'hsl(var(--secondary))', foreground: 'hsl(var(--secondary-foreground))' },
        muted: { DEFAULT: 'hsl(var(--muted))', foreground: 'hsl(var(--muted-foreground))' },
        accent: { DEFAULT: 'hsl(var(--accent))', foreground: 'hsl(var(--accent-foreground))' },
        destructive: { DEFAULT: 'hsl(var(--destructive))', foreground: 'hsl(var(--destructive-foreground))' },
        card: { DEFAULT: 'hsl(var(--card))', foreground: 'hsl(var(--card-foreground))' },
      },
      borderRadius: { lg: 'var(--radius)', md: 'calc(var(--radius) - 2px)', sm: 'calc(var(--radius) - 4px)' },
    },
  },
  plugins: [],
}
export default config
HEREDOC

# ── postcss.config.mjs ────────────────────────────────────────────
cat > "$TARGET/postcss.config.mjs" << 'HEREDOC'
const config = { plugins: { tailwindcss: {}, autoprefixer: {} } }
export default config
HEREDOC

# ── components.json ───────────────────────────────────────────────
cat > "$TARGET/components.json" << 'HEREDOC'
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.ts",
    "css": "src/app/globals.css",
    "baseColor": "slate",
    "cssVariables": true
  },
  "aliases": { "components": "@/components", "utils": "@/lib/utils" }
}
HEREDOC

# ── .gitignore ────────────────────────────────────────────────────
cat > "$TARGET/.gitignore" << 'HEREDOC'
/node_modules
/.next/
/out/
/build
.DS_Store
.env*.local
.vercel
*.tsbuildinfo
next-env.d.ts
HEREDOC

# ── .env.local.example ────────────────────────────────────────────
cat > "$TARGET/.env.local.example" << 'HEREDOC'
# GitHub Personal Access Token (scope: repo)
# Créer sur : https://github.com/settings/tokens
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Ton username GitHub
GITHUB_OWNER=ton-username

# Nom du repo (doit exister sur GitHub)
GITHUB_REPO=mon-cms-content

# Branche principale
GITHUB_BRANCH=main

# Visibilité : "private" ou "public"
GITHUB_REPO_VISIBILITY=private

# (Optionnel) Vercel Deploy Hook
VERCEL_DEPLOY_HOOK_URL=
HEREDOC

# ── src/app/globals.css ───────────────────────────────────────────
cat > "$TARGET/src/app/globals.css" << 'HEREDOC'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }
  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 48%;
  }
}
@layer base {
  * { @apply border-border; }
  body { @apply bg-background text-foreground; }
}

.tiptap { @apply min-h-[400px] p-4 focus:outline-none; }
.tiptap p.is-editor-empty:first-child::before { @apply text-muted-foreground pointer-events-none float-left h-0; content: attr(data-placeholder); }
.tiptap h1 { @apply text-3xl font-bold mb-4 mt-6; }
.tiptap h2 { @apply text-2xl font-bold mb-3 mt-5; }
.tiptap h3 { @apply text-xl font-bold mb-2 mt-4; }
.tiptap p { @apply mb-3 leading-relaxed; }
.tiptap ul { @apply list-disc pl-6 mb-3; }
.tiptap ol { @apply list-decimal pl-6 mb-3; }
.tiptap li { @apply mb-1; }
.tiptap blockquote { @apply border-l-4 border-primary pl-4 italic my-4 text-muted-foreground; }
.tiptap code { @apply bg-muted px-1.5 py-0.5 rounded text-sm font-mono; }
.tiptap pre { @apply bg-muted p-4 rounded-lg overflow-x-auto mb-4; }
.tiptap a { @apply text-primary underline; }
.tiptap img { @apply max-w-full rounded-lg my-4; }
.tiptap hr { @apply border-border my-6; }
.tiptap mark { @apply bg-yellow-200 px-0.5 rounded; }
.prose h1 { @apply text-3xl font-bold mb-4 mt-6; }
.prose h2 { @apply text-2xl font-bold mb-3 mt-5; }
.prose h3 { @apply text-xl font-bold mb-2 mt-4; }
.prose p { @apply mb-4 leading-relaxed; }
.prose ul { @apply list-disc pl-6 mb-4; }
.prose ol { @apply list-decimal pl-6 mb-4; }
.prose li { @apply mb-1; }
.prose blockquote { @apply border-l-4 border-primary pl-4 italic my-6 text-muted-foreground; }
.prose code { @apply bg-muted px-1.5 py-0.5 rounded text-sm font-mono; }
.prose pre { @apply bg-muted p-4 rounded-lg overflow-x-auto mb-4; }
.prose a { @apply text-primary underline hover:opacity-80; }
.prose img { @apply max-w-full rounded-lg my-6; }
HEREDOC

# ── src/app/layout.tsx ────────────────────────────────────────────
cat > "$TARGET/src/app/layout.tsx" << 'HEREDOC'
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
HEREDOC

# ── src/app/page.tsx ──────────────────────────────────────────────
cat > "$TARGET/src/app/page.tsx" << 'HEREDOC'
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
HEREDOC

# ── src/app/posts/[slug]/page.tsx ─────────────────────────────────
cat > "$TARGET/src/app/posts/[slug]/page.tsx" << 'HEREDOC'
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
export default async function PostPage({ params }: { params: { slug: string } }) {
  const post = await getPostBySlug(params.slug)
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
HEREDOC

# ── src/app/admin/page.tsx ────────────────────────────────────────
cat > "$TARGET/src/app/admin/page.tsx" << 'HEREDOC'
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
HEREDOC

# ── src/app/api/posts/route.ts ────────────────────────────────────
cat > "$TARGET/src/app/api/posts/route.ts" << 'HEREDOC'
import { getFile, listFiles, upsertFile, deleteFile } from '@/lib/github'
import { parseMarkdown, serializeMarkdown } from '@/lib/markdown'
import matter from 'gray-matter'
const FOLDER = 'content/posts'

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url)
  const slug = searchParams.get('slug')
  if (slug) {
    const file = await getFile(`${FOLDER}/${slug}.md`)
    if (!file) return Response.json(null, { status: 404 })
    return Response.json(parseMarkdown(file.content, slug))
  }
  const files = await listFiles(FOLDER)
  const posts = await Promise.all(files.map(async (f: { name: string }) => {
    const s = f.name.replace('.md', '')
    const file = await getFile(`${FOLDER}/${f.name}`)
    if (!file) return null
    const { data } = matter(file.content)
    return { ...data, slug: s }
  }))
  return Response.json(posts.filter(Boolean).sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()))
}

export async function POST(req: Request) {
  try {
    const { slug, frontmatter, content } = await req.json()
    if (!slug || !frontmatter?.title) return Response.json({ ok: false, error: 'slug et title requis' }, { status: 400 })
    const filePath = `${FOLDER}/${slug}.md`
    const fileContent = serializeMarkdown({ slug, ...frontmatter, content })
    const existing = await getFile(filePath)
    const result = await upsertFile(filePath, fileContent, existing ? `update(${slug}): ${frontmatter.title}` : `create(${slug}): ${frontmatter.title}`, existing?.sha)
    return Response.json({ ok: !!result })
  } catch (err) {
    return Response.json({ ok: false, error: String(err) }, { status: 500 })
  }
}

export async function DELETE(req: Request) {
  try {
    const { slug } = await req.json()
    if (!slug) return Response.json({ ok: false }, { status: 400 })
    const filePath = `${FOLDER}/${slug}.md`
    const existing = await getFile(filePath)
    if (!existing) return Response.json({ ok: false }, { status: 404 })
    const ok = await deleteFile(filePath, existing.sha, `delete(${slug})`)
    return Response.json({ ok })
  } catch (err) {
    return Response.json({ ok: false, error: String(err) }, { status: 500 })
  }
}
HEREDOC

# ── src/lib/github.ts ─────────────────────────────────────────────
cat > "$TARGET/src/lib/github.ts" << 'HEREDOC'
const BASE = 'https://api.github.com'
const headers = () => ({
  Authorization: `Bearer ${process.env.GITHUB_TOKEN}`,
  Accept: 'application/vnd.github+json',
  'Content-Type': 'application/json',
  'X-GitHub-Api-Version': '2022-11-28',
})
const repoBase = () => `${BASE}/repos/${process.env.GITHUB_OWNER}/${process.env.GITHUB_REPO}`

export async function getFile(filePath: string) {
  const res = await fetch(`${repoBase()}/contents/${filePath}`, { headers: headers(), cache: 'no-store' })
  if (!res.ok) return null
  const data = await res.json()
  return { content: Buffer.from(data.content, 'base64').toString('utf-8'), sha: data.sha as string }
}

export async function listFiles(folder: string) {
  const res = await fetch(`${repoBase()}/contents/${folder}`, { headers: headers(), cache: 'no-store' })
  if (!res.ok) return []
  const data = await res.json()
  if (!Array.isArray(data)) return []
  return data.filter((f: { name: string }) => f.name.endsWith('.md'))
}

export async function upsertFile(filePath: string, content: string, commitMessage: string, sha?: string) {
  const body: Record<string, unknown> = {
    message: commitMessage,
    content: Buffer.from(content, 'utf-8').toString('base64'),
    branch: process.env.GITHUB_BRANCH ?? 'main',
  }
  if (sha) body.sha = sha
  const res = await fetch(`${repoBase()}/contents/${filePath}`, { method: 'PUT', headers: headers(), body: JSON.stringify(body) })
  if (!res.ok) { console.error('GitHub upsertFile error:', await res.text()); return null }
  if (process.env.VERCEL_DEPLOY_HOOK_URL) await fetch(process.env.VERCEL_DEPLOY_HOOK_URL, { method: 'POST' }).catch(() => {})
  return await res.json()
}

export async function deleteFile(filePath: string, sha: string, commitMessage: string) {
  const res = await fetch(`${repoBase()}/contents/${filePath}`, {
    method: 'DELETE', headers: headers(),
    body: JSON.stringify({ message: commitMessage, sha, branch: process.env.GITHUB_BRANCH ?? 'main' }),
  })
  return res.ok
}

export async function setRepoVisibility(isPrivate: boolean) {
  const res = await fetch(repoBase(), { method: 'PATCH', headers: headers(), body: JSON.stringify({ private: isPrivate }) })
  return res.ok ? await res.json() : null
}
HEREDOC

# ── src/lib/markdown.ts ───────────────────────────────────────────
cat > "$TARGET/src/lib/markdown.ts" << 'HEREDOC'
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
HEREDOC

# ── src/components/Renderer.tsx ───────────────────────────────────
cat > "$TARGET/src/components/Renderer.tsx" << 'HEREDOC'
interface RendererProps { html: string }
export function Renderer({ html }: RendererProps) {
  return <div className="prose max-w-none" dangerouslySetInnerHTML={{ __html: html }} />
}
HEREDOC

# ── src/components/PostList.tsx ───────────────────────────────────
cat > "$TARGET/src/components/PostList.tsx" << 'HEREDOC'
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
HEREDOC

# ── src/components/Toolbar.tsx ────────────────────────────────────
cat > "$TARGET/src/components/Toolbar.tsx" << 'HEREDOC'
'use client'
import { Editor } from '@tiptap/react'
import { Bold, Italic, Underline, Strikethrough, Code, Heading1, Heading2, Heading3, List, ListOrdered, Quote, Minus, Link, Image, AlignLeft, AlignCenter, AlignRight, Highlighter, Undo, Redo } from 'lucide-react'
interface ToolbarProps { editor: Editor | null }
const Btn = ({ onClick, active, disabled, title, children }: { onClick: () => void; active?: boolean; disabled?: boolean; title: string; children: React.ReactNode }) => (
  <button onClick={onClick} disabled={disabled} title={title} className={`p-1.5 rounded transition-colors ${active ? 'bg-primary text-primary-foreground' : 'hover:bg-muted text-foreground'} ${disabled ? 'opacity-30 cursor-not-allowed' : 'cursor-pointer'}`}>{children}</button>
)
export function Toolbar({ editor }: ToolbarProps) {
  if (!editor) return null
  const addImage = () => { const url = window.prompt("URL de l'image"); if (url) editor.chain().focus().setImage({ src: url }).run() }
  const setLink = () => { const url = window.prompt('URL du lien'); if (url) editor.chain().focus().setLink({ href: url }).run(); else editor.chain().focus().unsetLink().run() }
  const sep = <div className="w-px bg-border mx-1" />
  return (
    <div className="flex flex-wrap gap-0.5 p-2 border-b border-border bg-muted/30">
      <Btn onClick={() => editor.chain().focus().undo().run()} disabled={!editor.can().undo()} title="Annuler"><Undo size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().redo().run()} disabled={!editor.can().redo()} title="Refaire"><Redo size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()} active={editor.isActive('heading', { level: 1 })} title="H1"><Heading1 size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()} active={editor.isActive('heading', { level: 2 })} title="H2"><Heading2 size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()} active={editor.isActive('heading', { level: 3 })} title="H3"><Heading3 size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().toggleBold().run()} active={editor.isActive('bold')} title="Gras"><Bold size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleItalic().run()} active={editor.isActive('italic')} title="Italique"><Italic size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleUnderline().run()} active={editor.isActive('underline')} title="Souligné"><Underline size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleStrike().run()} active={editor.isActive('strike')} title="Barré"><Strikethrough size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleCode().run()} active={editor.isActive('code')} title="Code"><Code size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleHighlight().run()} active={editor.isActive('highlight')} title="Surligner"><Highlighter size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().setTextAlign('left').run()} active={editor.isActive({ textAlign: 'left' })} title="Gauche"><AlignLeft size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().setTextAlign('center').run()} active={editor.isActive({ textAlign: 'center' })} title="Centre"><AlignCenter size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().setTextAlign('right').run()} active={editor.isActive({ textAlign: 'right' })} title="Droite"><AlignRight size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().toggleBulletList().run()} active={editor.isActive('bulletList')} title="Liste"><List size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleOrderedList().run()} active={editor.isActive('orderedList')} title="Liste numérotée"><ListOrdered size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleBlockquote().run()} active={editor.isActive('blockquote')} title="Citation"><Quote size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().setHorizontalRule().run()} title="Séparateur"><Minus size={16} /></Btn>
      {sep}
      <Btn onClick={setLink} active={editor.isActive('link')} title="Lien"><Link size={16} /></Btn>
      <Btn onClick={addImage} title="Image"><Image size={16} /></Btn>
    </div>
  )
}
HEREDOC

# ── src/components/Editor.tsx ─────────────────────────────────────
cat > "$TARGET/src/components/Editor.tsx" << 'HEREDOC'
'use client'
import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'
import ImageExtension from '@tiptap/extension-image'
import LinkExtension from '@tiptap/extension-link'
import PlaceholderExtension from '@tiptap/extension-placeholder'
import UnderlineExtension from '@tiptap/extension-underline'
import TextAlignExtension from '@tiptap/extension-text-align'
import HighlightExtension from '@tiptap/extension-highlight'
import { Toolbar } from './Toolbar'

interface EditorProps { content: string; onChange: (md: string) => void; placeholder?: string }

function htmlToMarkdown(html: string): string {
  return html
    .replace(/<h1>(.*?)<\/h1>/g, '# $1\n\n').replace(/<h2>(.*?)<\/h2>/g, '## $1\n\n').replace(/<h3>(.*?)<\/h3>/g, '### $1\n\n')
    .replace(/<strong>(.*?)<\/strong>/g, '**$1**').replace(/<em>(.*?)<\/em>/g, '*$1*').replace(/<u>(.*?)<\/u>/g, '_$1_')
    .replace(/<s>(.*?)<\/s>/g, '~~$1~~').replace(/<code>(.*?)<\/code>/g, '`$1`')
    .replace(/<a href="(.*?)">(.*?)<\/a>/g, '[$2]($1)').replace(/<img src="(.*?)".*?>/g, '![]($1)')
    .replace(/<blockquote>(.*?)<\/blockquote>/gs, (_, c) => `> ${c.trim()}\n\n`)
    .replace(/<li>(.*?)<\/li>/g, '- $1\n').replace(/<ul>|<\/ul>|<ol>|<\/ol>/g, '\n')
    .replace(/<hr\s*\/?>/g, '\n---\n\n').replace(/<p>(.*?)<\/p>/g, '$1\n\n').replace(/<br\s*\/?>/g, '\n')
    .replace(/<[^>]+>/g, '').replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'")
    .replace(/\n{3,}/g, '\n\n').trim()
}

function markdownToHtmlSimple(md: string): string {
  return md
    .replace(/^### (.*$)/gim, '<h3>$1</h3>').replace(/^## (.*$)/gim, '<h2>$1</h2>').replace(/^# (.*$)/gim, '<h1>$1</h1>')
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>').replace(/\*(.*?)\*/g, '<em>$1</em>').replace(/~~(.*?)~~/g, '<s>$1</s>')
    .replace(/`(.*?)`/g, '<code>$1</code>').replace(/\[(.*?)\]\((.*?)\)/g, '<a href="$2">$1</a>').replace(/!\[(.*?)\]\((.*?)\)/g, '<img src="$2" alt="$1">')
    .replace(/^> (.*$)/gim, '<blockquote>$1</blockquote>').replace(/^- (.*$)/gim, '<li>$1</li>').replace(/^---$/gim, '<hr>')
    .replace(/\n\n/g, '</p><p>').replace(/^(?!<[hH\d]|<li|<block|<hr|<img)(.+)$/gim, '<p>$1</p>')
}

export function Editor({ content, onChange, placeholder = 'Commencez à écrire...' }: EditorProps) {
  const editor = useEditor({
    extensions: [
      StarterKit,
      UnderlineExtension,
      HighlightExtension,
      TextAlignExtension.configure({ types: ['heading', 'paragraph'] }),
      ImageExtension.configure({ inline: false, allowBase64: true }),
      LinkExtension.configure({ openOnClick: false }),
      PlaceholderExtension.configure({ placeholder }),
    ],
    content: markdownToHtmlSimple(content),
    onUpdate: ({ editor }) => onChange(htmlToMarkdown(editor.getHTML())),
    editorProps: { attributes: { class: 'tiptap focus:outline-none' } },
  })
  return (
    <div className="border border-border rounded-lg overflow-hidden bg-card">
      <Toolbar editor={editor} />
      <EditorContent editor={editor} />
    </div>
  )
}
HEREDOC

# ── src/app/admin/edit/[slug]/page.tsx ────────────────────────────
cat > "$TARGET/src/app/admin/edit/[slug]/page.tsx" << 'HEREDOC'
'use client'
import { useState, useEffect, useCallback } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { Editor } from '@/components/Editor'
import { makeSlug } from '@/lib/markdown'
interface Frontmatter { title: string; date: string; excerpt: string; tags: string; status: 'draft' | 'published'; author: string }
export default function EditPage() {
  const params = useParams()
  const router = useRouter()
  const isNew = params.slug === 'new'
  const [content, setContent] = useState('')
  const [fm, setFm] = useState<Frontmatter>({ title: '', date: new Date().toISOString().split('T')[0], excerpt: '', tags: '', status: 'draft', author: '' })
  const [saving, setSaving] = useState(false)
  const [deleting, setDeleting] = useState(false)
  const [saved, setSaved] = useState(false)
  const [loading, setLoading] = useState(!isNew)
  useEffect(() => {
    if (isNew) return
    fetch(`/api/posts?slug=${params.slug}`).then((r) => r.json()).then((data) => {
      if (data) { setFm({ title: data.title ?? '', date: data.date ?? '', excerpt: data.excerpt ?? '', tags: Array.isArray(data.tags) ? data.tags.join(', ') : '', status: data.status ?? 'draft', author: data.author ?? '' }); setContent(data.content ?? '') }
      setLoading(false)
    }).catch(() => setLoading(false))
  }, [isNew, params.slug])
  const handleSave = useCallback(async () => {
    if (!fm.title.trim()) return alert('Le titre est obligatoire')
    setSaving(true)
    const slug = isNew ? makeSlug(fm.title) : (params.slug as string)
    const tags = fm.tags.split(',').map((t) => t.trim()).filter(Boolean)
    try {
      const res = await fetch('/api/posts', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ slug, frontmatter: { ...fm, tags }, content }) })
      const data = await res.json()
      if (data.ok) { setSaved(true); setTimeout(() => setSaved(false), 2000); if (isNew) router.push(`/admin/edit/${slug}`) }
      else alert('Erreur lors de la sauvegarde')
    } catch { alert('Erreur réseau') } finally { setSaving(false) }
  }, [fm, content, isNew, params.slug, router])
  const handleDelete = useCallback(async () => {
    if (!confirm('Supprimer cet article définitivement ?')) return
    setDeleting(true)
    try {
      const res = await fetch('/api/posts', { method: 'DELETE', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ slug: params.slug }) })
      const data = await res.json()
      if (data.ok) router.push('/admin'); else alert('Erreur lors de la suppression')
    } catch { alert('Erreur réseau') } finally { setDeleting(false) }
  }, [params.slug, router])
  if (loading) return <div className="flex items-center justify-center min-h-[60vh]"><div className="text-muted-foreground">Chargement...</div></div>
  return (
    <div className="max-w-5xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-3">
          <a href="/admin" className="text-sm text-muted-foreground hover:text-foreground">← Admin</a>
          <span className="text-muted-foreground">/</span>
          <span className="text-sm font-medium">{isNew ? 'Nouvel article' : fm.title || params.slug}</span>
        </div>
        <div className="flex items-center gap-3">
          {!isNew && <button onClick={handleDelete} disabled={deleting} className="px-4 py-2 text-sm rounded-lg border border-destructive text-destructive hover:bg-destructive hover:text-destructive-foreground transition-colors">{deleting ? 'Suppression...' : 'Supprimer'}</button>}
          {!isNew && <a href={`/posts/${params.slug}`} target="_blank" className="px-4 py-2 text-sm rounded-lg border border-border hover:bg-muted transition-colors">Voir</a>}
          <button onClick={handleSave} disabled={saving} className="px-5 py-2 text-sm rounded-lg bg-primary text-primary-foreground hover:opacity-90 transition-opacity font-medium">{saving ? 'Enregistrement...' : saved ? '✓ Enregistré !' : 'Enregistrer'}</button>
        </div>
      </div>
      <div className="grid grid-cols-3 gap-6">
        <div className="col-span-2 space-y-4">
          <input type="text" placeholder="Titre de l'article..." value={fm.title} onChange={(e) => setFm((f) => ({ ...f, title: e.target.value }))} className="w-full text-3xl font-bold bg-transparent border-0 outline-none placeholder:text-muted-foreground/50 pb-2 border-b border-border focus:border-primary transition-colors" />
          <Editor content={content} onChange={setContent} placeholder="Commencez à écrire votre article..." />
        </div>
        <div className="space-y-5">
          <div className="border border-border rounded-xl p-4 bg-card space-y-4">
            <h3 className="font-semibold text-sm">Publication</h3>
            <div><label className="text-xs text-muted-foreground mb-1.5 block">Statut</label><select value={fm.status} onChange={(e) => setFm((f) => ({ ...f, status: e.target.value as 'draft' | 'published' }))} className="w-full text-sm border border-border rounded-lg px-3 py-2 bg-background focus:outline-none focus:ring-2 focus:ring-primary"><option value="draft">Brouillon</option><option value="published">Publié</option></select></div>
            <div><label className="text-xs text-muted-foreground mb-1.5 block">Date</label><input type="date" value={fm.date} onChange={(e) => setFm((f) => ({ ...f, date: e.target.value }))} className="w-full text-sm border border-border rounded-lg px-3 py-2 bg-background focus:outline-none focus:ring-2 focus:ring-primary" /></div>
          </div>
          <div className="border border-border rounded-xl p-4 bg-card space-y-4">
            <h3 className="font-semibold text-sm">Métadonnées</h3>
            <div><label className="text-xs text-muted-foreground mb-1.5 block">Auteur</label><input type="text" placeholder="Vincent" value={fm.author} onChange={(e) => setFm((f) => ({ ...f, author: e.target.value }))} className="w-full text-sm border border-border rounded-lg px-3 py-2 bg-background focus:outline-none focus:ring-2 focus:ring-primary" /></div>
            <div><label className="text-xs text-muted-foreground mb-1.5 block">Tags (virgules)</label><input type="text" placeholder="tech, cms, next.js" value={fm.tags} onChange={(e) => setFm((f) => ({ ...f, tags: e.target.value }))} className="w-full text-sm border border-border rounded-lg px-3 py-2 bg-background focus:outline-none focus:ring-2 focus:ring-primary" /></div>
            <div><label className="text-xs text-muted-foreground mb-1.5 block">Extrait</label><textarea placeholder="Résumé court..." value={fm.excerpt} onChange={(e) => setFm((f) => ({ ...f, excerpt: e.target.value }))} rows={3} className="w-full text-sm border border-border rounded-lg px-3 py-2 bg-background focus:outline-none focus:ring-2 focus:ring-primary resize-none" /></div>
          </div>
          {!isNew && <div className="border border-border rounded-xl p-4 bg-card"><h3 className="font-semibold text-sm mb-2">Slug</h3><code className="text-xs text-muted-foreground bg-muted px-2 py-1 rounded break-all">{params.slug}</code></div>}
        </div>
      </div>
    </div>
  )
}
HEREDOC

# ── content/posts/premier-article.md ─────────────────────────────
cat > "$TARGET/content/posts/premier-article.md" << 'HEREDOC'
---
title: "Bienvenue sur mon CMS"
date: "2026-04-01"
excerpt: "Premier article de test pour découvrir les fonctionnalités du CMS."
tags: ["cms", "next.js", "markdown"]
status: "published"
author: "Vincent"
---

# Bienvenue sur mon CMS

Ceci est votre premier article. Stocké en **Markdown** dans GitHub.

## Fonctionnalités

- ✅ Éditeur WYSIWYG TipTap
- ✅ Stockage GitHub (private ou public)
- ✅ Frontmatter YAML
- ✅ Rebuild automatique Vercel

Bonne écriture ! 🚀
HEREDOC

echo ""
echo "📦 Installation des dépendances npm..."
cd "$TARGET"
npm install --legacy-peer-deps

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║             ✅  Installation terminée !          ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "👉 Prochaines étapes :"
echo ""
echo "   1.  cd $TARGET"
echo "   2.  cp .env.local.example .env.local"
echo "   3.  nano .env.local  →  renseigne GITHUB_TOKEN, GITHUB_OWNER, GITHUB_REPO"
echo "   4.  npm run dev"
echo "   5.  Ouvre http://localhost:3000/admin"
echo ""
echo "📘 Créer ton repo GitHub d'abord :"
echo "   https://github.com/new  →  nom : mon-cms-content  →  private ou public"
echo "   Puis crée un PAT sur : https://github.com/settings/tokens"
echo ""
