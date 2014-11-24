require 'rails_helper'

feature "FollowAndUnFollowTags", :type => :feature do
  let(:article) { FactoryGirl.create(:article, :with_tag) }
  let(:user) { FactoryGirl.create(:user) }

  background do
    login_as user, scope: :user
  end

  scenario "follow tag on tag show page" do
    visit tagged_articles_path(tag: article.tag_list.first)

    all(:link_or_button, I18n.t("tags.follow")).first.click
    expect(page).to have_link I18n.t("tags.unfollow")
  end

  scenario "follow tag on tag list page" do
    article
    visit tags_path

    within('article') do
      click_link I18n.t("tags.follow")
      expect(page).to have_link(I18n.t("tags.unfollow"))
      expect(page).to have_selector("td", text: "1", exact: true)
    end
  end

  scenario "unfollow tag on tag show page" do
    user.follow article.tag_list.first
    visit tagged_articles_path(tag: article.tag_list.first)

    all(:link_or_button, I18n.t("tags.unfollow")).first.click
    expect(page).to have_link I18n.t("tags.follow")
  end

  scenario "unfollow tag on tag list page" do
    user.follow article.tag_list.first
    visit tags_path

    within('article') do
      page.save_screenshot '/var/tmp/log1.png'
      click_link I18n.t("tags.unfollow")
      expect(page).to have_link(I18n.t("tags.follow"))
      page.save_screenshot '/var/tmp/log2.png'
      expect(page).to have_selector("td", text: "1", exact: true)
    end
  end

end
