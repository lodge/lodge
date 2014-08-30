class MarkdownPreview
  include ActiveModel::Model
  include Markdownable

  attr_accessor :body
  markdownable :body

end
