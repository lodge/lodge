require 'rails_helper'

RSpec.describe Stock, :type => :model do
  subject { FactoryGirl.create(:stock) }

  it { should belong_to(:user) }
  it { should belong_to(:article) }
  it { should validate_uniqueness_of(:user).scoped_to(:article_id) }
end
