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
  if (!res.ok) {
    const errorText = await res.text()
    console.error('GitHub upsertFile error:', errorText)
    return { ok: false as const, error: errorText }
  }
  if (process.env.VERCEL_DEPLOY_HOOK_URL) await fetch(process.env.VERCEL_DEPLOY_HOOK_URL, { method: 'POST' }).catch(() => {})
  const data = await res.json()
  return {
    ok: true as const,
    commitUrl: data.commit?.html_url as string | undefined,
    commitSha: (data.commit?.sha as string | undefined)?.slice(0, 7),
    fileUrl: data.content?.html_url as string | undefined,
  }
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
