# CMS Static

Headless CMS personnel basé sur Next.js, stockant les articles en Markdown sur GitHub.

## Stack

- **Next.js 15** (App Router)
- **TipTap** — éditeur WYSIWYG
- **Tailwind CSS** + **shadcn/ui**
- **GitHub API** — stockage des articles (`.md` avec frontmatter YAML)
- **gray-matter** — parsing frontmatter
- **remark** — rendu Markdown → HTML

## Architecture

```
src/
├── app/
│   ├── admin/              # Interface d'administration
│   │   ├── page.tsx        # Dashboard (liste + stats)
│   │   └── edit/[slug]/    # Éditeur d'article
│   ├── api/posts/          # API CRUD (GET / POST / DELETE)
│   ├── posts/[slug]/       # Vue publique d'un article
│   └── page.tsx            # Blog public (articles publiés)
├── components/
│   ├── Editor.tsx          # Éditeur TipTap
│   └── Toolbar.tsx         # Barre d'outils formatage
└── lib/
    ├── github.ts           # Appels GitHub API (upsert, delete, list)
    └── markdown.ts         # Parsing / sérialisation Markdown
content/
└── posts/                  # Articles .md (gérés via GitHub API)
```

## Configuration

Copier `.env.local.example` en `.env.local` :

```env
GITHUB_TOKEN=ghp_...           # Classic PAT avec scope "repo"
GITHUB_OWNER=magikcypress
GITHUB_REPO=cms-static
GITHUB_BRANCH=main
VERCEL_DEPLOY_HOOK_URL=        # Optionnel — rebuild auto après publication
```

## Lancer en local

```bash
npm install
npm run dev
# → http://localhost:3000
# → Admin : http://localhost:3000/admin
```

## Workflow

1. Créer / éditer un article sur `/admin/edit/[slug]`
2. Choisir le statut : **Brouillon** ou **Publié**
3. Cliquer **Enregistrer** — le fichier `.md` est commité sur GitHub
4. Une bannière confirme le commit avec le lien direct vers GitHub
5. Les articles `published` sont visibles sur `/`
