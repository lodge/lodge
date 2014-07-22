class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Kaminari.paginate_array(Article.tag_counts.order(id: :desc)).page(params[:page]).per(PER_SIZE)
    @following_tags = current_user.following_tag_list
  end
end
