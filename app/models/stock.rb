class Stock < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  after_create :create_notification

  validates_uniqueness_of :user, :scope => :article

  def create_notification
    article = self.article
    return if self.user_id == article.user_id
    notification = StockNotification.create!(
      user_id: self.user_id,
      state: :create,
      article_id: article.id,
    )
    notification.create_targets_for_owner_by_article(article)
  end
end
