require 'redcarpet'
require 'coderay'

module ArticlesHelper
  def stock_and_comment_count(article)
    stock_info = ""
    user_stock = article.stocks.find{ |stock| stock.user_id == current_user.id}
    if user_stock
      stock_image_and_count = %!#{image_tag("stocked.png")}#{article.stocks.size}!.html_safe
      stock_info = link_to stock_image_and_count, user_stock, method: :delete, class: "stock-link"
    else
      stock_image_and_count = %!#{image_tag("unstocked.png")}#{article.stocks.size}!.html_safe
      stock_info = link_to stock_image_and_count, {controller: "stocks", article_id: article.id}, method: :post, class: "stock-link"
    end

    comment_info = %!#{image_tag("comment.png")}#{article.comments.size}!.html_safe
    %!#{stock_info} #{comment_info}!.html_safe
  end

  def get_tags
    tag_value = ""
    if params[:article].present? 
      tag_value = params[:article][:tags] 
    else 
      tag_value = @article.tags.map {|tag| tag.name }.join(", ") 
    end 
  end
end
