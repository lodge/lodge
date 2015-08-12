module ApplicationHelper
  NO_TOC_TEXT = '--no-toc'

  def markdown(markdown)
    processor = Qiita::Markdown::Processor.new
    processor.filters << Lodge::Markdown::Filters::TargetBlankLink
    result = processor.call(markdown)
    result[:output].to_html
  end

  def markdown_toc(markdown_text)
    without_code_block_markdown =
      Lodge::Markdown::CodeBlockEraser.erase(markdown_text)
    toc_renderer = Qiita::Markdown::Greenmat::HTMLToCRenderer.new
    markdown = ::Greenmat::Markdown.new(toc_renderer, no_intra_emphasis: true)

    pipeline_context = { asset_root: "#{root_path}images", base_url: root_path }
    pipeline_filters = [
      HTML::Pipeline::EmojiFilter,
      Lodge::Markdown::Filters::TOC
    ]
    pipeline = HTML::Pipeline.new(pipeline_filters, pipeline_context)
    result = pipeline.call(markdown.render(without_code_block_markdown))
    return '' if result[:output].nil?
    result[:output].to_html
  end

  def user_name_with_icon(user)
    img = gravatar(user)
    a = content_tag :a, user.name, class: 'user-name', 'data-user-id' => user.id
    "#{img} #{a}".html_safe
  end

  def gravatar(user, size = 20, opt = {})
    opt = { class: ['user-icon'] }.merge(opt)
    url = 'http://www.gravatar.com/avatar/' + user.gravatar + '?size=' + size.to_s
    image_tag url, opt.merge(title: user.name, 'data-user-id' => user.id)
  end

  # tのキー先頭にコントローラ名を自動的に付与したもの。
  def tc(*args)
    args[0] = "#{params[:controller]}.#{args.first}"
    t(*args)
  end

  # tのキー先頭にcommonを自動的に付与したもの。
  def tco(*args)
    args[0] = "common.#{args.first}"
    t(*args)
  end

  # tcoのキー先頭にnotificationを自動的に付与したもの。
  def tcn(*args)
    args[0] = "notification.#{args.first}"
    tco(*args)
  end

  def notification_message(notification)
    localize_key = current_user == notification.article.user ?
      notification.localize_key_for_owner :
      notification.localize_key

    tcn(localize_key,
        user_name: notification.user.name,
        article_title: notification.article.title)
  end

  def notification_message_line(notification)
    message = content_tag :span, notification_message(notification)
    html = gravatar(notification.user, 40) + ' ' + message
    content_tag(:li, link_to(html, article_path(notification.article)))
  end

  def parse_filename(text)
    text.gsub(/(```[^:\r\n]*):([^\n\r]+)(\r|\n)/, "#{'\1'}\n@@@#{'\2'}@@@\n")
  end

  def next_uuid
    SecureRandom.uuid
  end

  def controller_stylesheet_link_tag
    stylesheet = "#{params[:controller]}.css"
    unless Rails.application.assets.find_asset(stylesheet).nil?
      stylesheet_link_tag stylesheet, media: 'all'
    end
  end

  def controller_javascript_include_tag
    # e.g. home_controller => assets/javascripts/home.js
    javascript = "#{params[:controller]}.js"
    unless Rails.application.assets.find_asset(javascript).nil?
      javascript_include_tag javascript
    end
  end
end
