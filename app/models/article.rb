class Article < ActiveRecord::Base
  order_by_updated_at_desc = ->{ order(updated_at: :desc) }
  order_by_updated_at_asc = ->{ order(updated_at: :asc) }
  belongs_to :user
  has_many :stocks
  has_many :comments, order_by_updated_at_asc
  has_many :update_histories, order_by_updated_at_desc
  has_many :notifications
  before_update :create_history
  before_update :create_notification
  has_many :stocked_users,
    -> {order "stocks.updated_at desc"},
    :through => :stocks,
    :source => :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true

  attr_accessor :old_title, :old_body, :old_tags, :new_tags, :update_user_id

  acts_as_taggable
  alias_method :__save, :save

  default_scope { order(created_at: :desc) }

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
      user_id: self.update_user_id,
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
      user_id: self.update_user_id,
      state: :update,
      article_id: self.id,
    )
    notification.create_targets_for_stocked_user_by_article(self)
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
