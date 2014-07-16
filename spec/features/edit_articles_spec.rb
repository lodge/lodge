require 'rails_helper'

feature "EditArticles", :type => :feature do
  let(:article) { FactoryGirl.create(:article, title: "old article", tag_list: "old_tag", body: "old body") }
  let(:user) { article.user }
  let(:stocked_user) { FactoryGirl.create(:user) }

  background do
    login_as stocked_user, scope: :user
    visit article_path(article)
    click_link I18n.t("articles.stock")
    logout
    login_as user, scope: :user
  end

  scenario "edit article and notify editiong to stocked user" do
    visit edit_article_path(article)
    fill_in I18n.t("activerecord.attributes.article.title"), with: "new article"
    fill_in I18n.t("activerecord.attributes.article.tags"), with: "tag1,tag2"
    fill_in I18n.t("activerecord.attributes.article.body"), with: "body"
    click_button I18n.t("helpers.submit.update")

    expect(page).to have_content("new article")
    expect(page).to have_content("tag1")
    expect(page).to have_content("tag2")
    expect(page).to have_content("body")

    click_link "#{I18n.t("articles.update_histories")}(1)"
    first(:link,"new article").click
    expect(page).to have_content(I18n.t("update_histories.current_article", article_title: "new article"))
    expect(page).to have_content("-old article")
    expect(page).to have_content("+new article")
    expect(page).to have_content("-old_tag")
    expect(page).to have_content("+tag1,tag2")
    expect(page).to have_content("-old body")
    expect(page).to have_content("+body")
    logout

    login_as stocked_user, scope: :user
    visit root_path
    find("#num-of-notification").click # TODO: to write more declarative
    expect(page).to have_content(I18n.t("common.notification.article_update", user_name: user.name, article_title: "new article"))
  end
end
