import { NextResponse } from 'next/server'
import { COOKIE_NAME, computeToken } from '@/lib/auth'

export async function POST(req: Request) {
  const { password } = await req.json()
  if (!password) return NextResponse.json({ ok: false }, { status: 400 })

  const expected = await computeToken()
  if (!expected) return NextResponse.json({ ok: false, error: 'ADMIN_PASSWORD non configuré' }, { status: 500 })

  // Comparaison en temps constant pour éviter timing attacks
  const provided = await (async () => {
    const data = new TextEncoder().encode('cms:' + password)
    const hash = await crypto.subtle.digest('SHA-256', data)
    return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('')
  })()

  if (provided !== expected) {
    return NextResponse.json({ ok: false }, { status: 401 })
  }

  const res = NextResponse.json({ ok: true })
  res.cookies.set(COOKIE_NAME, expected, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    path: '/',
    maxAge: 60 * 60 * 24 * 7, // 7 jours
  })
  return res
}

export async function DELETE() {
  const res = NextResponse.json({ ok: true })
  res.cookies.delete(COOKIE_NAME)
  return res
}
