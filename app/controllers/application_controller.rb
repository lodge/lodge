require 'awesome_print'

class ApplicationController < ActionController::Base
  LodgeSettings = Settings.lodge
  PER_SIZE = LodgeSettings.per_size
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  #before_action :read_tags, except: [:sign_in, :sign_up]
  before_action :read_stocks, except: [:sign_in, :sign_up]
  before_action :read_notification, except: [:sign_in, :sign_up]
  before_action :read_user_articles, except: [:sign_in, :sign_up]
  before_action :load_pre_url
  before_action :set_pre_url, except: [:new, :edit, :show, :create, :update, :destroy, :sign_up, :preview, :list]

  def read_stocks
    @stocked_articles = []
    return unless current_user
    @stocked_articles = current_user.stocked_articles.order("stocks.updated_at desc").limit(PER_SIZE)
  end

  def read_user_articles
    return unless current_user
    @user_articles = current_user.articles.order("articles.updated_at desc").limit(PER_SIZE)
  end

  def read_tags
    return unless current_user
    @tags = Article.new.tag_counts_on(:tags).order("count DESC")
  end

  def read_notification
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
