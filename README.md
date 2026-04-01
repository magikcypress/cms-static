# CMS Static

Personal headless CMS built with Next.js, storing articles as Markdown files on GitHub.

## Stack

- **Next.js 16** (App Router)
- **TipTap** — WYSIWYG editor
- **Tailwind CSS** + **shadcn/ui**
- **GitHub API** — article storage (`.md` files with YAML frontmatter)
- **gray-matter** — frontmatter parsing
- **remark** + **sanitize-html** — Markdown → sanitized HTML

## Architecture

```
src/
├── app/
│   ├── admin/              # Admin interface (protected)
│   │   ├── login/          # Login page
│   │   ├── page.tsx        # Dashboard (list + stats)
│   │   └── edit/[slug]/    # Article editor
│   ├── api/
│   │   ├── auth/           # POST login / DELETE logout
│   │   └── posts/          # CRUD API (GET / POST / DELETE)
│   ├── posts/[slug]/       # Public article view
│   └── page.tsx            # Public blog (published articles)
├── components/
│   ├── Editor.tsx          # TipTap editor
│   └── Toolbar.tsx         # Formatting toolbar
├── lib/
│   ├── auth.ts             # Auth helpers (cookie, SHA-256 token)
│   ├── github.ts           # GitHub API calls (upsert, delete, list)
│   └── markdown.ts         # Markdown parsing / serialization
└── proxy.ts                # Edge proxy — protects /admin/* routes
content/
└── posts/                  # .md articles (managed via GitHub API)
```

## Configuration

Copy `.env.local.example` to `.env.local`:

```env
GITHUB_TOKEN=ghp_...              # Classic PAT with "repo" scope
GITHUB_OWNER=your-username
GITHUB_REPO=your-repo
GITHUB_BRANCH=main
GITHUB_REPO_VISIBILITY=private    # "private" enables admin auth, "public" disables it
ADMIN_PASSWORD=changeme           # Only used when GITHUB_REPO_VISIBILITY=private
NEXT_PUBLIC_SITE_URL=https://your-site.com
VERCEL_DEPLOY_HOOK_URL=           # Optional — auto-rebuild after publishing
```

## Authentication

Admin access is controlled by `GITHUB_REPO_VISIBILITY`:

| Value | Behavior |
|-------|----------|
| `private` | Login required — password set via `ADMIN_PASSWORD` |
| `public` | No login required — admin is open |

The session cookie is `httpOnly`, `secure` in production, and valid for 7 days. The password is never stored — only its SHA-256 hash is compared.

## Run locally

```bash
npm install
npm run dev
# → http://localhost:3000
# → Admin: http://localhost:3000/admin
```

## Workflow

1. Create or edit an article at `/admin/edit/[slug]`
2. Choose a status: **Draft** or **Published**
3. Click **Save** — the `.md` file is committed to GitHub
4. A banner confirms the commit with a direct link to GitHub
5. Articles with status `published` appear on `/`

## Deploy to Vercel

Push to `main` — Vercel auto-deploys. Make sure to set all environment variables in **Settings → Environment Variables**, including `ADMIN_PASSWORD` if your repo is private.
