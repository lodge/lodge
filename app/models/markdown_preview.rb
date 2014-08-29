class MarkdownPreview
  extend ActiveModel
  include Markdownable

  attr_accessor :body
  markdownable :body

  def initialize(body)
    @body = body
  end
end
