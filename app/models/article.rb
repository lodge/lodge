class Article < ActiveRecord::Base

  # TODO: sould use ".env"
  LodgeSettings = Settings.lodge
  PER_SIZE = LodgeSettings.per_size

  belongs_to :user
  has_many :stocks
  has_many :comments
  has_many :update_histories
  has_many :notifications
  has_many :article_notifications
  before_update :create_history, unless: :draft?
  before_update :create_notification
  has_many :stocked_users,
    -> {order "stocks.updated_at desc"},
    :through => :stocks,
    :source => :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true

  attr_accessor :update_user_id

  acts_as_taggable
  alias_method :__save, :save

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :owned_draft, ->(user) {
    draft.where(user_id: user.id).includes(:user, :stocks, :tags).order(:updated_at => :desc)
  }

  # ===== SunSpot =====
  searchable do
    text :title, :body, :stored => true
    text :comments do
      comments.map { |comment| comment.body }
    end
    string :user do
      user.name.downcase
    end
    string :tags, :multiple => true do
      tags.map do |t|
        t.name.downcase
      end
    end
    time :created_at
  end

  # ===== Class methods =====

  def self.recent_list(page=1)
    Article
      .published
      .includes(:user, :stocks, :tags)
      .page(page).per(PER_SIZE)
      .order(:created_at => :desc)
  end

  def self.feed_list(user, page=1)
    Article
      .published
      .includes(:user, :stocks, :tags)
      .page(page).per(PER_SIZE)
      .tagged_with(user.following_tag_list, any: true)
      .order(:created_at => :desc)
  end

  def self.stocked_by(user, page=1)
    user.stocked_articles
        .includes(:tags, :stocks, :user)
        .page(page).per(PER_SIZE).order(:created_at => :desc)
  end

  def self.owned_by(user, page=1)
    user.articles
        .includes(:tags, :stocks)
        .page(page).per(PER_SIZE).order(:created_at => :desc)
  end

  def self.tagged_by(tag, page=1)
    Article
        .includes(:stocks, :user)
        .page(page).per(PER_SIZE).tagged_with(tag).order(:created_at => :desc)
  end

  # ===== Instance methods =====

  def last_updated_user
    update_histories.order(created_at: :desc).first.user
  end

  def draft?
    new_record? || !published?
  end

  def save
    begin
      __save
    rescue ActiveRecord::StaleObjectError
      errors.add :lock_version, :article_already_updated
      false
    end
  end

  def create_history
    update_histories.create(
      user_id: update_user_id,
      old_title: title_was,
      old_tags: tag_list_was.to_s,
      old_body: body_was,
      new_title: title,
      new_tags: tag_list.to_s,
      new_body: body,
    )
  end

  def create_notification
    notification = ArticleNotification.create!(
      user_id: self.update_user_id,
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

  def self.tag_counts
    ActsAsTaggableOn::Tag
      .includes(:taggings)
      .references(:taggings)
      .where(taggings: {taggable_type: 'Article', context: 'tags'})
  end
end
