class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Article.tag_counts.page(params[:page]).per(PER_SIZE).order(id: :desc)
    @following_tags = current_user.following_tag_list
  end
end
