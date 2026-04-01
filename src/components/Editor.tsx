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
    immediatelyRender: false,
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
