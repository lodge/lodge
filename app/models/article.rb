class Article < ActiveRecord::Base
  belongs_to :user
  has_many :stocks
  has_many :comments
  has_many :update_histories
  has_many :notifications
  has_many :article_notifications
  before_update :create_history
  before_update :create_notification
  has_many :stocked_users,
    -> {order "stocks.updated_at desc"},
    :through => :stocks,
    :source => :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true

  attr_accessor :old_title, :old_body, :old_tags, :new_tags

  acts_as_taggable
  alias_method :__save, :save

  def save
    begin
      __save
    rescue ActiveRecord::StaleObjectError
      errors.add :lock_version, :article_already_updated
      false
    end
  end

  def create_history
    UpdateHistory.create!(
      article_id: self.id,
      old_title: self.old_title,
      old_tags: self.old_tags,
      old_body: self.old_body,
      new_title: self.title,
      new_tags: self.new_tags,
      new_body: self.body,
    )
  end

  def create_notification
    notification = ArticleNotification.create!(
      user_id: self.user_id,
      state: :update,
      article_id: self.id,
    )
    notification.create_targets_for_stocked_user_by_article(self)
    notification
  end

  def remove_user_notification(current_user)
    notifications = ArticleNotification.includes(:notification_targets).where(article_id: self.id)
    notifications += CommentNotification.includes(:notification_targets).where(article_id: self.id)
    notifications += StockNotification.includes(:notification_targets).where(article_id: self.id)
    NotificationTarget.destroy_all(notification_id: notifications.map {|n| n.id }, user_id: current_user.id)
    notifications.each do |notification|
      notification.destroy! if notification.notification_targets.length == 0
    end
  end
end
