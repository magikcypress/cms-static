'use client'
import { useState, useEffect, useCallback } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { Editor } from '@/components/Editor'
import { makeSlug } from '@/lib/markdown'

interface Frontmatter { title: string; date: string; excerpt: string; tags: string; status: 'draft' | 'published'; author: string }
interface SaveResult { commitUrl?: string; commitSha?: string; fileUrl?: string; verified: boolean; verifiedStatus?: string }

export default function EditPage() {
  const params = useParams()
  const router = useRouter()
  const isNew = params.slug === 'new'
  const [content, setContent] = useState('')
  const [fm, setFm] = useState<Frontmatter>({ title: '', date: new Date().toISOString().split('T')[0], excerpt: '', tags: '', status: 'draft', author: '' })
  const [saving, setSaving] = useState(false)
  const [deleting, setDeleting] = useState(false)
  const [saveResult, setSaveResult] = useState<SaveResult | null>(null)
  const [saveError, setSaveError] = useState<string | null>(null)
  const [loading, setLoading] = useState(!isNew)

  useEffect(() => {
    if (isNew) return
    fetch(`/api/posts?slug=${params.slug}`).then((r) => r.json()).then((data) => {
      if (data) {
        setFm({ title: data.title ?? '', date: data.date ?? '', excerpt: data.excerpt ?? '', tags: Array.isArray(data.tags) ? data.tags.join(', ') : '', status: data.status ?? 'draft', author: data.author ?? '' })
        setContent(data.content ?? '')
      }
      setLoading(false)
    }).catch(() => setLoading(false))
  }, [isNew, params.slug])

  const handleSave = useCallback(async () => {
    if (!fm.title.trim()) return alert('Le titre est obligatoire')
    setSaving(true)
    setSaveResult(null)
    setSaveError(null)
    const slug = isNew ? makeSlug(fm.title) : (params.slug as string)
    const tags = fm.tags.split(',').map((t) => t.trim()).filter(Boolean)
    try {
      const res = await fetch('/api/posts', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ slug, frontmatter: { ...fm, tags }, content }) })
      const data = await res.json()
      if (data.ok) {
        setSaveResult({ commitUrl: data.commitUrl, commitSha: data.commitSha, fileUrl: data.fileUrl, verified: data.verified, verifiedStatus: data.verifiedStatus })
        if (isNew) router.push(`/admin/edit/${slug}`)
      } else {
        setSaveError(data.error ?? 'Erreur lors de la sauvegarde')
      }
    } catch { setSaveError('Erreur réseau') } finally { setSaving(false) }
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

  const statusMismatch = saveResult && fm.status !== saveResult.verifiedStatus

  return (
    <div className="max-w-5xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <a href="/admin" className="text-sm text-muted-foreground hover:text-foreground">← Admin</a>
          <span className="text-muted-foreground">/</span>
          <span className="text-sm font-medium">{isNew ? 'Nouvel article' : fm.title || params.slug}</span>
        </div>
        <div className="flex items-center gap-3">
          {!isNew && <button onClick={handleDelete} disabled={deleting} className="px-4 py-2 text-sm rounded-lg border border-destructive text-destructive hover:bg-destructive hover:text-destructive-foreground transition-colors">{deleting ? 'Suppression...' : 'Supprimer'}</button>}
          {!isNew && <a href={`/posts/${params.slug}`} target="_blank" className="px-4 py-2 text-sm rounded-lg border border-border hover:bg-muted transition-colors">Voir</a>}
          <button onClick={handleSave} disabled={saving} className="px-5 py-2 text-sm rounded-lg bg-primary text-primary-foreground hover:opacity-90 transition-opacity font-medium">
            {saving ? 'Enregistrement...' : 'Enregistrer'}
          </button>
        </div>
      </div>

      {/* Bannière de confirmation GitHub */}
      {saveResult && (
        <div className={`mb-4 rounded-lg border px-4 py-3 text-sm flex items-start gap-3 ${statusMismatch ? 'border-yellow-300 bg-yellow-50 text-yellow-800' : 'border-green-300 bg-green-50 text-green-800'}`}>
          <span className="text-base">{statusMismatch ? '⚠️' : '✓'}</span>
          <div className="flex-1 space-y-1">
            <div className="font-medium">
              {statusMismatch
                ? `Statut GitHub (${saveResult.verifiedStatus}) ≠ statut local (${fm.status}) — sauvegardez à nouveau`
                : `Enregistré sur GitHub${saveResult.verified ? ` · statut vérifié : ${saveResult.verifiedStatus}` : ''}`}
            </div>
            <div className="flex flex-wrap gap-3 text-xs">
              {saveResult.commitUrl && (
                <a href={saveResult.commitUrl} target="_blank" rel="noopener noreferrer" className="underline hover:no-underline">
                  Voir le commit {saveResult.commitSha && `#${saveResult.commitSha}`}
                </a>
              )}
              {saveResult.fileUrl && (
                <a href={saveResult.fileUrl} target="_blank" rel="noopener noreferrer" className="underline hover:no-underline">
                  Voir le fichier sur GitHub
                </a>
              )}
              {!saveResult.verified && <span className="text-yellow-700">⚠ Vérification GitHub échouée</span>}
            </div>
          </div>
          <button onClick={() => setSaveResult(null)} className="text-current opacity-50 hover:opacity-100">✕</button>
        </div>
      )}

      {/* Bannière d'erreur */}
      {saveError && (
        <div className="mb-4 rounded-lg border border-red-300 bg-red-50 text-red-800 px-4 py-3 text-sm flex items-center gap-3">
          <span>✕</span>
          <span className="flex-1">{saveError}</span>
          <button onClick={() => setSaveError(null)} className="opacity-50 hover:opacity-100">✕</button>
        </div>
      )}

      <div className="grid grid-cols-3 gap-6">
        <div className="col-span-2 space-y-4">
          <input type="text" placeholder="Titre de l'article..." value={fm.title} onChange={(e) => { setFm((f) => ({ ...f, title: e.target.value })); setSaveResult(null) }} className="w-full text-3xl font-bold bg-transparent border-0 outline-none placeholder:text-muted-foreground/50 pb-2 border-b border-border focus:border-primary transition-colors" />
          <Editor content={content} onChange={(v) => { setContent(v); setSaveResult(null) }} placeholder="Commencez à écrire votre article..." />
        </div>
        <div className="space-y-5">
          <div className="border border-border rounded-xl p-4 bg-card space-y-4">
            <h3 className="font-semibold text-sm">Publication</h3>
            <div>
              <label className="text-xs text-muted-foreground mb-1.5 block">Statut</label>
              <select value={fm.status} onChange={(e) => { setFm((f) => ({ ...f, status: e.target.value as 'draft' | 'published' })); setSaveResult(null) }} className="w-full text-sm border border-border rounded-lg px-3 py-2 bg-background focus:outline-none focus:ring-2 focus:ring-primary">
                <option value="draft">Brouillon</option>
                <option value="published">Publié</option>
              </select>
            </div>
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
