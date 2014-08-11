require 'rails_helper'

feature "DraftLists", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }

  background do
    login_as user, scope: :user
    FactoryGirl.create :article, title: "article"
    FactoryGirl.create :draft, title: "draft"
  end

  scenario "visit to draft list" do
    visit draft_articles_path
    expect(page).to have_content("draft");
    expect(page).not_to have_content("article");
  end
end
