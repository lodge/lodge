require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to :user }
  it { should belong_to :article }
  it { should validate_presence_of(:body) }

  it_should_behave_like 'having markdownable', :body
end
