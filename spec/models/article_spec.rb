require 'rails_helper'

RSpec.describe Article, :type => :model do
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(100) }

  it { should validate_presence_of(:body) }

  it { should belong_to(:user) }
  it { should have_many(:stocks) }
  it { should have_many(:comments) }
  it { should have_many(:stocked_users) }
  it { should have_many(:tags) }
  it { should have_many(:article_notifications) }

  describe "list methods" do
    let(:user) { FactoryGirl.create(:user) }
    let(:args) { nil }

    shared_examples_for 'ordered list' do |method_name|
      before do
        2.times do |i|
          article = FactoryGirl.create(:article, :with_tag,
            user_id: user.id,
            created_at: '2014-09-24 00:00:' + (10 + i).to_s,
            updated_at: '2014-09-24 00:00:' + (59 - i).to_s
          )
          user.stock(article)
          user.follow(article.tags.first)
        end
      end

      subject(:articles) { Article.send(method_name, *args) }

      it 'has two articles' do
        expect(articles.each.size).to be_eql(2)
      end
      it 'is creation order' do
        expect(articles.first.created_at).to be > articles.last.created_at
      end
    end

    describe :recent_list do
      it_should_behave_like 'ordered list', 'recent_list'
    end

    describe :tagged_by do
      let(:args) { 'tag' }
      it_should_behave_like 'ordered list', 'tagged_by'
    end

    describe :stocked_by do
      let(:args) { user }
      it_should_behave_like 'ordered list', 'stocked_by'
    end

    describe :owned_by do
      let(:args) { user }
      it_should_behave_like 'ordered list', 'owned_by'
    end

    describe :feed_list do
      let(:args) { user }
      it_should_behave_like 'ordered list', 'feed_list'
    end
  end

  describe :draft? do
    context "when new record" do
      subject { FactoryGirl.build(:article) }

      it { should be_draft }
    end

    context "when draft record" do
      subject { FactoryGirl.create(:draft) }

      it { should be_draft }
    end

    context "when published record" do
      subject { FactoryGirl.create(:article) }

      it { should_not be_draft }
    end
  end

  describe :owned_draft do
    let(:draft1) { FactoryGirl.create(:draft) }
    let(:draft2) { FactoryGirl.create(:draft) }
    before { [draft1, draft2] }

    subject { Article.owned_draft(draft1.user) }

    it { should contain_exactly(draft1) }
  end

  describe :save do
    let(:article) { FactoryGirl.create(:article) }
    let(:before_user) { FactoryGirl.create(:user) }
    let(:after_user) { FactoryGirl.create(:user) }

    before do
      article.title = "edited title"
      article.update_user_id = before_user.id
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
        same_article.update_user_id = after_user.id
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
    let(:user) { FactoryGirl.create(:user) }

    before do
      article.title = "new title"
      article.body = "new body"
      article.tag_list = "newtag1,newtag2"
      article.update_user_id = user.id
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
    let(:user) { FactoryGirl.create(:user) }

    before do
      article.update_user_id = user.id
    end

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
