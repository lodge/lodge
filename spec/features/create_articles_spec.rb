require 'rails_helper'

feature "CreateArticles", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:tags) { %w(tag0 tag1 tag2 tag3 tag4 tag5 tag6 tag7 tag8 tag9) }

  background do
    login_as user, scope: :user
  end

  scenario "create new article" do

    tags = %w(tag0 tag1 tag2 tag3 tag4 tag5 tag6 tag7 tag8 tag9)
    new_article_title = "new article"

    expect {
      visit new_article_path
      fill_in I18n.t("activerecord.attributes.article.title"), with: new_article_title
      fill_in_autocomplete("#article_tag_list", tags.join(","))
      fill_in I18n.t("activerecord.attributes.article.body"), with: "body"
      check I18n.t("articles.publish")
      click_button I18n.t("helpers.submit.create")
    }.to change(Article, :count).by(1)

    expect(page).to have_content(new_article_title)
    tags.each do |tag|
      expect(page).to have_link(tag, href: tagged_articles_path(tag: tag))
    end
    expect(page).to have_content("body")

    click_link I18n.t("common.user_article_list_title")
    expect(page).to have_link(new_article_title)

    click_link I18n.t("common.recent_article_list_title")
    expect(page).to have_link(new_article_title)
  end

  scenario "create new draft" do

    expect {
      visit new_article_path
      fill_in I18n.t("activerecord.attributes.article.title"), with: "new draft"
      fill_in_autocomplete("#article_tag_list", tags.join(","))
      fill_in I18n.t("activerecord.attributes.article.body"), with: "body"
      uncheck I18n.t("articles.publish")
      click_button I18n.t("helpers.submit.create")
    }.to change(Article, :count).by(1)

    visit articles_path
    within "article" do
      expect(page).not_to have_content("new draft")
    end

    visit feed_articles_path
    within "article" do
      expect(page).not_to have_content("new draft")
    end

    visit owned_articles_path(user)
    within "article" do
      expect(page).to have_content("new draft")
    end
  end
end
