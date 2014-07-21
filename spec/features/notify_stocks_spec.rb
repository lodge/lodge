require 'rails_helper'

feature "NotifyStocks", :type => :feature do
  let(:article) { FactoryGirl.create(:article) }
  let(:user) { FactoryGirl.create(:user) }
  background do
    login_as user, scope: :user
  end

  scenario "notify stocked article" do
    visit article_path(article)
    click_link I18n.t("articles.stock")
    expect(page).to have_content(I18n.t("articles.stocked_users"))

    click_link I18n.t("common.stocked_article_list_title")
    expect(page).to have_link(article.title)

    click_link I18n.t("common.feed_article_list_title")
    expect(page).to have_link(article.title)
    logout

    login_as(article.user)
    visit root_path
    find("#num-of-notification").click # TODO: to write more declarative
    expect(page).to have_content(I18n.t("common.notification.stock_for_owner", user_name: user.name, article_title: article.title))
  end
end
