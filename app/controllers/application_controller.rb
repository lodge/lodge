require 'awesome_print'

class ApplicationController < ActionController::Base
  LodgeSettings = Settings.lodge
  PER_SIZE = LodgeSettings.per_size
  RIGHT_LIST_SIZE = LodgeSettings.right_list_size
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  #before_action :read_tags, except: [:sign_in, :sign_up]
  before_action :read_recent_feed, except: [:sign_in, :sign_up]
  before_action :read_recent_articles, except: [:sign_in, :sign_up]
  before_action :read_stocks, except: [:sign_in, :sign_up]
  before_action :read_notifications, except: [:sign_in, :sign_up]
  before_action :read_user_articles, except: [:sign_in, :sign_up]
  before_action :read_popular_articles, except: [:sign_in, :sign_up]
  before_action :read_recent_tags, except: [:sign_in, :sign_up]
  before_action :load_pre_url
  before_action :set_pre_url, except: [:new, :edit, :show, :create, :update, :destroy, :sign_up, :preview, :list]

  def read_recent_feed
    return unless current_user
    @recent_feed = Article.tagged_with(current_user.following_tag_list, any: true)
      .order(:created_at => :desc).limit(RIGHT_LIST_SIZE)
  end

  def read_recent_articles
    @recent_articles = []
    return unless current_user
    @recent_articles = Article.order("created_at DESC").limit(RIGHT_LIST_SIZE)
  end

  def read_stocks
    @stocked_articles = []
    return unless current_user
    @stocked_articles = current_user.stocked_articles.order("stocks.updated_at desc").limit(RIGHT_LIST_SIZE)
  end

  def read_user_articles
    return unless current_user
    @user_articles = current_user.articles.order("articles.updated_at desc").limit(RIGHT_LIST_SIZE)
  end

  def read_popular_articles
    return unless current_user
    popular_stocks = Stock.joins(:article)
      .where("articles.created_at > ?", 2.week.ago)
      .group("stocks.article_id", "articles.updated_at")
      .order("count_article_id desc", "articles.updated_at desc")
      .limit(RIGHT_LIST_SIZE)
      .count(:article_id)
    popular_articles = Article.includes(:stocks).where(id: popular_stocks.keys.map{|x| x.first})
    @popular_articles = []
    popular_stocks.each do |keys, count|
      @popular_articles << popular_articles.select {|a| a.id == keys.first}.first
    end
  end

  def read_recent_tags
    @recent_tags = []
    return unless current_user
    @recent_tags = Article.new.tag_counts_on(:tags).order("id DESC").limit(RIGHT_LIST_SIZE)
  end

  def read_notifications
    @notifications = []
    return unless current_user
    @notifications = Notification
      .joins(:notification_targets)
      .includes({:article => :user}, :user)
      .where("notification_targets.user_id = ?", current_user.id)
      .order(:updated_at => :desc)
  end

  def load_pre_url
    @pre_accessable_url = session[:pre_accessable_url]
  end

  def set_pre_url
    session[:pre_accessable_url] = request.url
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

end
