module Lodge
  module Markdown
    module Filters
      class TargetBlankLink < HTML::Pipeline::Filter
        def call
          return if doc.children.blank?
          doc.search('a').each do |a|
            next if a['href'] =~ %r{\Ahttps?://#{ENV['LODGE_DOMAIN']}/|\A(.|/)}
            a['target'] = '_blank'
          end
          doc
        end
      end
    end
  end
end
