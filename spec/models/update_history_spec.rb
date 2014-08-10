require 'rails_helper'

RSpec.describe UpdateHistory, :type => :model do
  it { should belong_to(:article) }

  context "with article modification" do
    let(:article) { FactoryGirl.create(:article) }

    before do
      article.title = "modify title"
    end

    it "is created" do
      expect { article.save }.to change(UpdateHistory, :count).by(1)
    end
  end

  context "with draft modification" do
    let(:draft) { FactoryGirl.create(:draft) }

    before do
      draft.title = "modify title"
    end

    it "is created" do
      expect { draft.save }.to_not change(UpdateHistory, :count)
    end
  end
end
