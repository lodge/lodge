require 'rails_helper'

RSpec.describe UpdateHistory, :type => :model do
  it { should belong_to(:article) }
end
