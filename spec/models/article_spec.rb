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
  it { should have_many(:article_notifications) }

  describe :save do
    let(:article) { FactoryGirl.create(:article) }
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

  describe :create_history do
    let(:article) { FactoryGirl.create(:article, title: "old title", body: "old body", tag_list: "oldtag") }

    before do
      article.title = "new title"
      article.body = "new body"
      article.tag_list = "newtag1,newtag2"
    end

    it "should create new update_history" do
      expect { article.create_history }.to change(UpdateHistory, :count).by(1)
    end

    it "should be related with the new update_history" do
      expect(article.create_history.article).to be_eql(article)
    end

    context :created_update_history do
      subject { article.create_history }

      its(:old_title) { should eq 'old title' }
      its(:old_body) { should eq 'old body' }
      its(:old_tags) { should eq 'oldtag' }
      its(:new_title) { should eq 'new title' }
      its(:new_body) { should eq 'new body' }
      its(:new_tags) { should eq 'newtag1, newtag2' }
    end
  end

  describe :create_notification do
    let(:article) { FactoryGirl.create(:article) }

    it "should create new notification" do
      expect { article.create_notification }.to change(Notification, :count).by(1)
    end

    it "should be related with the notification" do
      expect(article.create_notification.article).to be_eql(article)
    end

    it "should create article notification" do
      expect(article.create_notification).to be_instance_of(ArticleNotification)
    end

    it "should create update-notification" do
      expect(article.create_notification.state).to be_eql(:update)
    end
  end

  describe :remove_user_notification do
    let(:article) {
      article = FactoryGirl.build(:article)
      article.tag_list = "tag1,tag2"
      article.save
    }
  end
end
