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
    visit edit_article_path(article)
    new_title = "new article"
    new_tag_list = "tag1,tag2"
    new_body = "body"
    fill_in I18n.t("activerecord.attributes.article.title"), with: new_title
    fill_in I18n.t("activerecord.attributes.article.tag_list"), with: new_tag_list
    fill_in I18n.t("activerecord.attributes.article.body"), with: new_body
    click_button I18n.t("helpers.submit.update")

    expect(page).to have_content(new_title)
    tags = new_tag_list.split(",")
    expect(page).to have_link(tags.first)
    expect(page).to have_link(tags.last)
    expect(page).to have_content(new_body)

    click_link I18n.t("articles.update_histories")
    expect(page).to have_content(I18n.t("update_histories.current_article", article_title: new_title))

    first(:link, new_title).click
    expect(page).to have_content(I18n.t("update_histories.current_article", article_title: new_title))
    expect(page).to have_content("-old article")
    expect(page).to have_content("+#{new_title}")
    expect(page).to have_content("-old_tag")
    expect(page).to have_content("+#{new_tag_list.gsub(",", ", ")}")
    expect(page).to have_content("-old body")
    expect(page).to have_content("+#{new_body}")
    logout

    login_as stocked_user, scope: :user
    visit root_path
    find("#num-of-notification").click # TODO: to write more declarative
    expect(page).to have_content(I18n.t("common.notification.article_update", user_name: user.name, article_title: new_title))
  end
end
