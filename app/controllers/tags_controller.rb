class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.page(params[:page]).per(PER_SIZE).where("taggings_count > ?", 0).order(id: :desc)
    @following_tags = FollowingTag.includes(:tag).where(user_id: current_user.id)
  end
end
