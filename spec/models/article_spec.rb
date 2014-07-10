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

  describe :create_history do
    let(:article) { FactoryGirl.create(:edited_article) }

    it "should create new update_history" do
      expect { article.create_history }.to change(UpdateHistory, :count).by(1)
    end
    it "should be related with the new update_history" do
      expect(article.create_history.article).to be_eql(article)
    end
  end

  describe :save do
    let(:article) { FactoryGirl.create(:edited_article) }
    before do
      article.title = "edited title"
    end

    context "when article is free" do
      it "should update article" do
        expect { article.save }.to change(article, :title_was).to("edited title")
      end
    end

    context "when article is locked" do
      before do
        same_article = Article.find(article.id)
        same_article.old_title = same_article.title
        same_article.old_body = same_article.body
        same_article.old_tags = same_article.tag_list.to_s
        same_article.title = "new title"
        same_article.body = "new body"
        same_article.tag_list = "newtag1,newtag2"
        same_article.save
        article.save
      end

      it "should become error" do
        expect(article.errors.size).to be_eql(1)
      end
    end
  end
end
