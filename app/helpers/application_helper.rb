module ApplicationHelper
  NO_TOC_TEXT = "--no-toc"

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

  def markdown_toc(text)
    return "" if text.match(/^#{NO_TOC_TEXT}/)
    html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC, fenced_code_blocks: true)
    # 引用ができなくなるのを防ぐため、エスケープ後 「>」 記号だけ元に戻す。
    toc = html_toc.render(text)
    toc = "<h1>#{tc(:index_title)}</h1> #{toc}<hr>" unless toc.blank?
    toc
  end

  def markdown(text, with_toc=true)
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
    text = html_escape(text).gsub("&gt;", ">").gsub(/\r?\n/, "  \n")
    toc = with_toc ? markdown_toc(text) : ""
    text.sub!(/^#{NO_TOC_TEXT}/, "")
    html = markdown.render(parse_filename(text)).gsub("&amp;", "&")
    toc + html
  end

  def user_name_with_icon(user)
    img = gravatar(user)
    a = content_tag :a, user.name, class: "user-name", "data-user-id" => user.id
    %!#{img} #{a}!.html_safe
  end

  def gravatar(user, size=20, opt={})
    opt = { class: ["user-icon"] }.merge(opt)
    url = "http://www.gravatar.com/avatar/" + user.gravatar + "?size=" + size.to_s
    image_tag url, opt.merge(title: user.name, "data-user-id" => user.id)
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
    html = gravatar(notification.user, 40) + " " + message
    content_tag(:li, link_to(html, article_path(notification.article)))
  end

  def parse_filename(text)
    text.gsub(/(```[^:\r\n]*):([^\n\r]+)(\r|\n)/, "#{'\1'}\n@@@#{'\2'}@@@\n")
  end

  def next_uuid
    SecureRandom.uuid
  end
end
