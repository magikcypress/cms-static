interface RendererProps { html: string }
export function Renderer({ html }: RendererProps) {
  return <div className="prose max-w-none" dangerouslySetInnerHTML={{ __html: html }} />
}
