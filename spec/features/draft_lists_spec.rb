require 'rails_helper'

feature "DraftLists", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }

  background do
    login_as user, scope: :user
    FactoryGirl.create :article, title: "article", user: user
    FactoryGirl.create :draft, title: "draft", user: user
  end

  scenario "visit to draft list" do
    visit draft_articles_path
    within 'article' do
      expect(page).to have_content("draft");
      expect(page).not_to have_content("article");
    end
  end
end
