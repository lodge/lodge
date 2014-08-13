require 'rails_helper'

feature "FollowTags", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:article, tag_list: "tag1") }
  background do
    article
    login_as user, scope: :user
  end

  scenario "stock article" do
    visit tags_path
    click_link I18n.t("tags.follow")
    expect(page).to have_link(I18n.t("tags.unfollow"))

    visit feed_articles_path
    expect(page).to have_content article.title
  end
end
