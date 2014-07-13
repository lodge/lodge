require 'rails_helper'

RSpec.describe NotificationTarget, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:notification) }
end
