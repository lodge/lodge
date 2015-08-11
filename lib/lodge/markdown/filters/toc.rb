module Lodge
  module Markdown
    module Filters
      class TOC < HTML::Pipeline::Filter
        CSS_CLASS_NAME = 'markdown-toc'

        def call
          return if doc.children.blank?
          toc_area_fragment = Nokogiri::HTML.fragment(%Q[<div class="#{CSS_CLASS_NAME}">])
          toc_heading = Nokogiri::HTML.fragment(%Q[<h1>#{I18n.t('articles.index_title')}</h1>])
          toc_area = toc_area_fragment.at('div')
          toc_area.add_child(toc_heading)
          toc_area.add_child(doc.children.first)
          doc.children.first.replace(toc_area_fragment)
          doc.children << Nokogiri::HTML.fragment('<hr>')
        end
      end

      class TargetBlankLink < HTML::Pipeline::Filter
        def call
          return if doc.children.blank?
          doc.search('a').each do |a|
            a['target'] = '_blank'
          end
          doc
        end
      end
    end
  end
end
