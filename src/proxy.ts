import { NextRequest, NextResponse } from 'next/server'
import { COOKIE_NAME, computeToken } from '@/lib/auth'

export async function proxy(req: NextRequest) {
  // No auth required if the repo is public
  if (process.env.GITHUB_REPO_VISIBILITY !== 'private') return NextResponse.next()

  const { pathname } = req.nextUrl

  // Login page is always accessible
  if (pathname === '/admin/login') return NextResponse.next()

  const token = req.cookies.get(COOKIE_NAME)?.value
  if (!token) return NextResponse.redirect(new URL('/admin/login', req.url))

  const expected = await computeToken()
  if (!expected || token !== expected) {
    const res = NextResponse.redirect(new URL('/admin/login', req.url))
    res.cookies.delete(COOKIE_NAME)
    return res
  }

  return NextResponse.next()
}

export const proxyConfig = {
  matcher: ['/admin/:path*'],
}
