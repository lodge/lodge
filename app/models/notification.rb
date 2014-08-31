class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  has_many :notification_targets
  has_many :targets, :through => :notification_targets, :source => :user

  def create_targets_for_owner_by_article(article)
    NotificationTarget.create!(
      notification_id: self.id,
      user_id: article.user_id
    )
  end

  def create_targets_for_stocked_user_by_article(article)
    targets = []
    article.stocks.each do |stock|
      next if stock.user_id == article.user_id
      targets << NotificationTarget.new(
        notification_id: self.id,
        user_id: stock.user_id
      )
    end
    targets << NotificationTarget.new(
      notification_id: self.id,
      user_id: article.user_id
    )
    NotificationTarget.import targets
  end

  def localize_key_for_owner
    "#{localize_key}_for_owner"
  end
end
