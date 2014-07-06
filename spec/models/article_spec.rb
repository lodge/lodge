require 'rails_helper'

RSpec.describe Article, :type => :model do
  it { should validate_presence_of(:title) }
  it { should ensure_length_of(:title).is_at_most(100) }

  it { should validate_presence_of(:body) }

  it { should belong_to(:user) }
  it { should have_many(:stocks) }
  it { should have_many(:comments) }
  it { should have_many(:stocked_users) }
  it { should have_many(:tags) }
end
