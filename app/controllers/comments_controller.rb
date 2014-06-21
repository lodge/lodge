class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  before_action :check_permission, only: [:update, :destroy]

  # POST /comments
  # POST /comments.json
  def create
    comment = Comment.new(comment_params)
    article = comment.article
    respond_to do |format|
      if comment.save
        format.html { redirect_to article, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: article }
      else
        format.html { redirect_to article, alert: "Failed to create comment." }
        format.json { render json: comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  def update
    article = @comment.article
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to article, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: article }
      else
        format.html { redirect_to article, alert: "Failed to update comment." }
        format.json { render json: comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.article }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:user_id, :article_id, :body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def check_permission
    return if @comment.user_id == current_user.id
    redirect_to articles_url
  end
end
