require 'digest/md5'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable
  validates_presence_of :name
  before_save :generate_gravatar

  has_many :articles
  has_many :stocked_articles,
    -> {order "stocks.updated_at desc"},
    :through => :stocks,
    :source => :article
  has_many :stocks
  has_many :comments
  has_many :notification_targets
  has_many :notifications,
    -> {order "notifications.updated_at desc"},
    :through => :notification_targets,
    :source => :notification

  acts_as_taggable_on :following_tags

  def generate_gravatar
    self.gravatar = Digest::MD5.hexdigest(self.email)
  end

  def follow?(tag)
    following_tag_list.include? tag
  end

  def follow(tag)
    following_tag_list << tag
    save
  end

  def unfollow(tag)
    following_tag_list.remove(tag)
    save
  end

  def contribution
    Stock.joins(:article).where("articles.user_id = ? AND stocks.user_id != ?", self.id, self.id).count
  end

  def recent_articles(count=20)
    articles.order(updated_at: :desc).limit(count)
  end

  def stock?(article)
    stocked_articles.include?(article)
  end

  def stock(article)
    stocked_articles << article
    save
  end

  def unstock(article)
    stocked_articles.delete(article)
    save
  end

  def self.find_for_google_oauth2(auth)
    user = User.where(email: auth.info.email).first

    unless user
      user = User.create(name:     auth.info.name,
                         provider: auth.provider,
                         uid:      auth.uid,
                         email:    auth.info.email,
                         token:    auth.credentials.token,
                         password: Devise.friendly_token[0, 20])
    end
    user
  end
end
