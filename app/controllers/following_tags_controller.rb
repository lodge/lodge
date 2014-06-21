class FollowingTagsController < ApplicationController
  before_action :set_following_tag, only: [:destroy]
  before_action :check_permission, only: [:destroy]
  before_action :following_tag_params, only: [:create, :destroy]

  # POST /articles
  # POST /articles.json
  def create
    @following_tag = FollowingTag.new(following_tag_params)
    @following_tag.user_id = current_user.id
    respond_to do |format|
      if @following_tag.save
        format.html { redirect_to :back, notice: 'Tag was successfully followed.' }
        format.json { render :show, status: :created, location: @following_tag }
      else
        format.html { redirect_to :back, error: 'Tag was failure followed.' }
        format.json { render json: @following_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @following_tag.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Tag was successfully unfollowed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def following_tag_params
    params.permit(:tag_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def check_permission
    return if @following_tag.user_id == current_user.id
    redirect_to articles_url
  end

  def set_following_tag
    @following_tag = FollowingTag.where(tag_id: params[:tag_id], user_id: current_user.id).first
    ap @following_tag
  end
end
