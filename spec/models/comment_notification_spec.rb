require 'rails_helper'

RSpec.describe CommentNotification, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:article) }
  it { should have_many(:notification_targets) }
  it { should have_many(:targets) }
end
