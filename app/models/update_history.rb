class UpdateHistory < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  default_scope {order(updated_at: :desc)}

  alias_method :__user, :user

  # This method for compatibility of old version.
  def user
    __user || article.user
  end
end
