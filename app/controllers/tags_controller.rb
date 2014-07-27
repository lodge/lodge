class TagsController < ApplicationController
  before_action :set_tag, only: [:follow, :unfollow]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Article.tag_counts.page(params[:page]).per(PER_SIZE).order(id: :desc)
    @following_tags = current_user.following_tag_list
  end

  def follow
    current_user.follow(@tag)
  end

  def unfollow
    current_user.unfollow(@tag)
    render :follow
  end

private

  def set_tag
    @tag = params[:tag]
  end
end
