require 'rails_helper'

RSpec.describe FollowingTag, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:tag) }
end
