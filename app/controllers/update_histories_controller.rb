class UpdateHistoriesController < ApplicationController
  before_action :set_update_history, only: [:show]

  # GET /update_histories
  # GET /update_histories.json
  def list
    @article = Article.find(params[:article_id])
    @update_histories = UpdateHistory.where(article_id: @article.id).order(created_at: :desc)
  end

  # GET /update_histories/1
  # GET /update_histories/1.json
  def show
    @article = @update_history.article
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_update_history
      @update_history = UpdateHistory.find(params[:id])
    end
end
