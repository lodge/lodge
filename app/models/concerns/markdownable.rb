module Markdownable
  extend ActiveSupport::Concern

  module ClassMethods
    def markdownable(*fields)
      fields.each do |field|
        define_method "#{field}_html" do
          Markdownable.markdown(self.send(field))
        end
        define_method "#{field}_toc" do
          Markdownable.markdown_toc(self.send(field))
        end
      end
    end
  end

  NO_TOC_TEXT = "--no-toc"

  def self.markdown(text)
    html = GitHub::Markdown.render_gfm(text.sub(NO_TOC_TEXT, ''))
    doc = Nokogiri::HTML.fragment(html)

    doc.css('pre[lang]').each do |pre|
      lang, name = *pre['lang'].split(':', 2)

      code = Nokogiri::HTML.fragment(CodeRay.scan(pre.children.first.text, lang).div)
      if !name.blank?
        header = Nokogiri::XML::Element.new('div', doc).tap do |h|
          h['class'] = 'code-filename'
          h.content = name
        end
        code.children.first.add_previous_sibling header
      end

      pre.replace(code)
    end

    doc.css('h1,h2,h3,h4,h5,h6').each do |h|
      h['id'] = h.text.gsub(/\s/, '-')
    end

    doc.to_s
  end

  def self.markdown_toc(text)
    return "" if text.match(/^#{NO_TOC_TEXT}/)
    Redcarpet::Markdown.new(
        Redcarpet::Render::HTML_TOC,
        fenced_code_blocks: true)
      .render(text)
      .tap do |toc|
        break "<h1>#{I18n.t('articles.index_title')}</h1> #{toc}<hr>" unless toc.blank?
      end
  end

end
