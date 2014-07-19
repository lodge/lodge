require 'rails_helper'

feature "CreateArticles", :type => :feature do
  let (:user) { FactoryGirl.create(:user) }
  background do
    login_as user, scope: :user
  end

  scenario "create new article" do
    expect {
      visit new_article_path
      fill_in I18n.t("activerecord.attributes.article.title"), with: "new article"
      fill_in I18n.t("activerecord.attributes.article.tags"), with: "tag1,tag2"
      fill_in I18n.t("activerecord.attributes.article.body"), with: "body"
      click_button I18n.t("helpers.submit.create")
    }.to change(Article, :count).by(1)

    expect(page).to have_content("new article")
    expect(page).to have_link("tag1")
    expect(page).to have_link("tag2")
    expect(page).to have_content("body")

    click_link I18n.t("common.user_article_list_title")
    expect(page).to have_link("new article")

    click_link I18n.t("common.feed_article_list_title")
    expect(page).to have_link("new article")
  end
end
