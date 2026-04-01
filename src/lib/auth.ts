import { cookies } from 'next/headers'

export const COOKIE_NAME = 'cms_session'

/** SHA-256 du mot de passe — fonctionne en Edge et Node.js */
export async function computeToken(): Promise<string> {
  const password = process.env.ADMIN_PASSWORD ?? ''
  if (!password) return ''
  const data = new TextEncoder().encode('cms:' + password)
  const hash = await crypto.subtle.digest('SHA-256', data)
  return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('')
}

export async function isAuthenticated(): Promise<boolean> {
  const cookieStore = await cookies()
  const token = cookieStore.get(COOKIE_NAME)?.value
  if (!token) return false
  const expected = await computeToken()
  return expected !== '' && token === expected
}
