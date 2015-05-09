module Lodge
  module Markdown
    class CodeBlockEraser
      def self.erase(markdown)
        is_code = false
        new_lines = []
        markdown.lines do |line|
          if /^```/ === line
            is_code = !is_code 
          else
            new_lines << line if !is_code
          end
        end
        new_lines.join('')
      end
    end
  end
end
