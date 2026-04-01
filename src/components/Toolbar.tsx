'use client'
import { Editor } from '@tiptap/react'
import { Bold, Italic, Underline, Strikethrough, Code, Heading1, Heading2, Heading3, List, ListOrdered, Quote, Minus, Link, Image, AlignLeft, AlignCenter, AlignRight, Highlighter, Undo, Redo } from 'lucide-react'
interface ToolbarProps { editor: Editor | null }
const Btn = ({ onClick, active, disabled, title, children }: { onClick: () => void; active?: boolean; disabled?: boolean; title: string; children: React.ReactNode }) => (
  <button onClick={onClick} disabled={disabled} title={title} className={`p-1.5 rounded transition-colors ${active ? 'bg-primary text-primary-foreground' : 'hover:bg-muted text-foreground'} ${disabled ? 'opacity-30 cursor-not-allowed' : 'cursor-pointer'}`}>{children}</button>
)
export function Toolbar({ editor }: ToolbarProps) {
  if (!editor) return null
  const addImage = () => { const url = window.prompt("URL de l'image"); if (url) editor.chain().focus().setImage({ src: url }).run() }
  const setLink = () => { const url = window.prompt('URL du lien'); if (url) editor.chain().focus().setLink({ href: url }).run(); else editor.chain().focus().unsetLink().run() }
  const sep = <div className="w-px bg-border mx-1" />
  return (
    <div className="flex flex-wrap gap-0.5 p-2 border-b border-border bg-muted/30">
      <Btn onClick={() => editor.chain().focus().undo().run()} disabled={!editor.can().undo()} title="Annuler"><Undo size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().redo().run()} disabled={!editor.can().redo()} title="Refaire"><Redo size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()} active={editor.isActive('heading', { level: 1 })} title="H1"><Heading1 size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()} active={editor.isActive('heading', { level: 2 })} title="H2"><Heading2 size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()} active={editor.isActive('heading', { level: 3 })} title="H3"><Heading3 size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().toggleBold().run()} active={editor.isActive('bold')} title="Gras"><Bold size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleItalic().run()} active={editor.isActive('italic')} title="Italique"><Italic size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleUnderline().run()} active={editor.isActive('underline')} title="Souligné"><Underline size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleStrike().run()} active={editor.isActive('strike')} title="Barré"><Strikethrough size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleCode().run()} active={editor.isActive('code')} title="Code"><Code size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleHighlight().run()} active={editor.isActive('highlight')} title="Surligner"><Highlighter size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().setTextAlign('left').run()} active={editor.isActive({ textAlign: 'left' })} title="Gauche"><AlignLeft size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().setTextAlign('center').run()} active={editor.isActive({ textAlign: 'center' })} title="Centre"><AlignCenter size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().setTextAlign('right').run()} active={editor.isActive({ textAlign: 'right' })} title="Droite"><AlignRight size={16} /></Btn>
      {sep}
      <Btn onClick={() => editor.chain().focus().toggleBulletList().run()} active={editor.isActive('bulletList')} title="Liste"><List size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleOrderedList().run()} active={editor.isActive('orderedList')} title="Liste numérotée"><ListOrdered size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().toggleBlockquote().run()} active={editor.isActive('blockquote')} title="Citation"><Quote size={16} /></Btn>
      <Btn onClick={() => editor.chain().focus().setHorizontalRule().run()} title="Séparateur"><Minus size={16} /></Btn>
      {sep}
      <Btn onClick={setLink} active={editor.isActive('link')} title="Lien"><Link size={16} /></Btn>
      <Btn onClick={addImage} title="Image"><Image size={16} /></Btn>
    </div>
  )
}
