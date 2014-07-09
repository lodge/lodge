require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_many(:following_tags) }
  it { should have_many(:articles) }
  it { should have_many(:stocked_articles) }
  it { should have_many(:stocks) }
  it { should have_many(:comments) }
  it { should have_many(:notification_targets) }
  it { should have_many(:notifications) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
end
