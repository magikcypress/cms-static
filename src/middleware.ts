import { NextRequest, NextResponse } from 'next/server'
import { COOKIE_NAME, computeToken } from '@/lib/auth'

export async function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl

  // La page de login est accessible sans auth
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

export const config = {
  matcher: ['/admin/:path*'],
}
