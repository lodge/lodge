require 'redcarpet'
require 'coderay'

module ArticlesHelper
  def stock_and_comment_count(article)
    stock_info = stock_and_count_link(article)
    comment_info = comment_image_and_count(article)
    %!#{stock_info} #{comment_info}!.html_safe
  end

  def stock_and_count_link(article)
    user_stock = article.stocks.find{ |stock| stock.user_id == current_user.id}
    if user_stock
      link_to %!#{image_tag("stocked.png")}#{article.stocks.size}!.html_safe, user_stock, method: :delete, class: "stock-link", title: tco(:unstock)
    else
      link_to %!#{image_tag("unstocked.png")}#{article.stocks.size}!.html_safe, {controller: "/stocks", article_id: article.id}, method: :post, class: "stock-link", title: tco(:stock)
    end
  end

  def comment_image_and_count(article)
    content_tag :span, title: tco(:comment) do
      %!#{image_tag("comment.png")}#{article.comments.size}!.html_safe
    end
  end
end
