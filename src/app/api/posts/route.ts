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
  type Post = { date?: string; slug: string; [key: string]: unknown }
  return Response.json((posts.filter(Boolean) as Post[]).sort((a, b) => new Date(b.date ?? 0).getTime() - new Date(a.date ?? 0).getTime()))
}

export async function POST(req: Request) {
  try {
    const { slug, frontmatter, content } = await req.json()
    if (!slug || !frontmatter?.title) return Response.json({ ok: false, error: 'slug et title requis' }, { status: 400 })
    const filePath = `${FOLDER}/${slug}.md`
    const fileContent = serializeMarkdown({ slug, ...frontmatter, content })
    const existing = await getFile(filePath)
    const result = await upsertFile(
      filePath,
      fileContent,
      existing ? `update(${slug}): ${frontmatter.title}` : `create(${slug}): ${frontmatter.title}`,
      existing?.sha,
    )
    if (!result?.ok) return Response.json({ ok: false, error: result?.error ?? 'GitHub error' }, { status: 502 })

    // Vérification : relire le fichier sur GitHub pour confirmer le statut
    const verification = await getFile(filePath)
    const verified = verification !== null
    const verifiedStatus = verified ? matter(verification.content).data.status : null

    return Response.json({
      ok: true,
      isNew: !existing,
      commitUrl: result.commitUrl,
      commitSha: result.commitSha,
      fileUrl: result.fileUrl,
      verified,
      verifiedStatus,
    })
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
