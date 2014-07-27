require 'rails_helper'

RSpec.describe User, :type => :model do
  subject (:user) { FactoryGirl.create(:user) }

  it { should have_many(:following_tags) }
  it { should have_many(:articles) }
  it { should have_many(:stocked_articles) }
  it { should have_many(:stocks) }
  it { should have_many(:comments) }
  it { should have_many(:notification_targets) }
  it { should have_many(:notifications) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }

  describe :stock? do
    let (:article) { FactoryGirl.create (:article) }

    context "with stocked article" do
      before do
        stock = FactoryGirl.create(:stock, user_id: user.id, article_id: article.id)
      end

      it "returns true" do
        expect(user.stock?(article)).to be_truthy
      end
    end

    context "with unstocked article" do
      before do
        stock = FactoryGirl.create(:stock, article_id: article.id)
      end

      it "returns false" do
        expect(user.stock?(article)).to be_falsy
      end
    end
  end

  describe :stock do
    let (:article) { FactoryGirl.create(:article) }

    before do
      user.stock(article)
    end

    it "stocks article" do
      expect(user.stock?(article)).to be_truthy
    end
  end

  describe :unstock do
    let (:article) { FactoryGirl.create(:article, :with_stock) }
    subject (:user) { article.stocks[0].user }

    before do
      user.unstock(article)
    end

    it "doesn't stock article" do
      expect(user.stock?(article)).to be_falsy
    end
  end

  describe "follow" do
    let (:article) { FactoryGirl.create(:article, :with_tag) }

    before do
      user.follow(article.tag_list.first)
    end

    it "follow tag" do
      expect(user.following_tag_list).to eq([article.tag_list.first])
    end
  end

  describe "unfollow" do
    let (:article) { FactoryGirl.create(:article, :with_tag) }

    before do
      user.following_tag_list << article.tag_list.first
      user.save

      user.unfollow(article.tag_list)
    end

    it "follow tag" do
      expect(user.following_tag_list).to eq([])
    end
  end

end
