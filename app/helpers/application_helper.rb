module ApplicationHelper

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
