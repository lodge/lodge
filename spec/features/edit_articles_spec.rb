require 'rails_helper'

feature "EditArticles", :type => :feature do
  let(:article) { FactoryGirl.create(:article, title: "old article", tag_list: "old_tag", body: "old body") }
  let(:user) { article.user }
  let(:stocked_user) { FactoryGirl.create(:user) }

  background do
    stocked_user.stock(article)
    login_as user, scope: :user
  end

  scenario "edit article and notify stocked user" do

    tags = %w(tag0 tag1 tag2 tag3 tag4 tag5 tag6 tag7 tag8 tag9)

    visit edit_article_path(article)
    fill_in I18n.t("activerecord.attributes.article.title"), with: "new article"
    fill_in_autocomplete("#article_tag_list", tags.join(","))
    fill_in I18n.t("activerecord.attributes.article.body"), with: "body"
    click_button I18n.t("helpers.submit.update")

    expect(page).to have_content("new article")
    tags.each do |tag|
      expect(page).to have_link(tag, href: tagged_articles_path(tag: tag))
    end
    expect(page).to have_content("body")

    click_link I18n.t("articles.update_histories")
    expect(page).to have_content(I18n.t("update_histories.current_article", article_title: "new article"))

    first(:link,"new article").click
    expect(page).to have_content(I18n.t("update_histories.current_article", article_title: "new article"))
    expect(page).to have_content("-old article")
    expect(page).to have_content("+new article")
    expect(page).to have_content("-old_tag")
    expect(page).to have_content("+#{tags.join(', ')}")
    expect(page).to have_content("-old body")
    expect(page).to have_content("+body")
    logout

    login_as stocked_user, scope: :user
    visit root_path
    find("#num-of-notification").click # TODO: to write more declarative
    expect(page).to have_content(I18n.t("common.notification.article_update", user_name: user.name, article_title: "new article"))
  end
end
