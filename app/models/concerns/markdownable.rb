module Markdownable
  extend ActiveSupport::Concern

  module ClassMethods
    def markdownable(*fields)
      fields.each do |field|
        define_method "#{field}_html_with_toc" do
          text = self.send(field)
          Markdownable.markdown(text, true)
        end
        define_method "#{field}_html" do
          text = self.send(field)
          Markdownable.markdown(text, false)
        end
      end
    end
  end

  class ArticlesRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      code.sub!(/(@@@[^\n]+@@@\n)/, "")
      title = $1 || ""
      begin
        code = CGI.unescapeHTML code
        code = CodeRay.scan(code, language).div()
        code.sub(/^/, create_filename_row(title))
      rescue
        self.block_code(title + code, :text)
      end
    end

    def initialize(extensions = {})
      super extensions.merge(link_attributes: { target: "_blank" })
    end

    def create_filename_row(filename)
      return "" if filename.empty?
      %!<div class="code-filename">#{filename.gsub("@@@", "")}</div>!
    end
  end

  NO_TOC_TEXT = "--no-toc"

  def self.markdown(text, with_toc)
    renderer = ArticlesRenderer.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      space_after_headers: false,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
      superscript: true
    )
    # 引用ができなくなるのを防ぐため、エスケープ後 「>」 記号だけ元に戻す。
    text = ERB::Util.html_escape(text).gsub("&gt;", ">").gsub(/\r?\n/, "  \n")
    toc = with_toc ? markdown_toc(text) : ""
    text.sub!(/^#{NO_TOC_TEXT}/, "")
    html = markdown.render(parse_filename(text)).gsub("&amp;", "&")
    toc + html
  end

  def self.markdown_toc(text)
    return "" if text.match(/^#{NO_TOC_TEXT}/)
    html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC, fenced_code_blocks: true)
    # 引用ができなくなるのを防ぐため、エスケープ後 「>」 記号だけ元に戻す。
    toc = html_toc.render(text)
    toc = "<h1>#{I18n.t('articles.index_title')}</h1> #{toc}<hr>" unless toc.blank?
    toc
  end

  def self.parse_filename(text)
    text.gsub(/(```[^:\r\n]*):([^\n\r]+)(\r|\n)/, "#{'\1'}\n@@@#{'\2'}@@@\n")
  end


end
