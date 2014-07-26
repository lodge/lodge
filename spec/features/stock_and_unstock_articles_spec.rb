require 'rails_helper'

feature "StockAndUnstockArticles", :type => :feature do
  let(:article) { FactoryGirl.create(:article) }
  let(:user) { article.user }

  background do
    login_as user, scope: :user
  end


  scenario "stock article on article show page" do
    visit article_path(article)

    within('article') do
      click_link I18n.t("articles.stock")
      expect(page).to have_link I18n.t("articles.unstock")
      expect(page).to have_link("1", exact: true)
      within('.stock-users') do
        expect(page).to have_selector("img[src*='#{user.gravatar}']")
      end
    end
  end

  scenario "stock article on article list page" do
    visit articles_path

    within('article') do
      click_link("0", exact: true)
      expect(page).to have_link("1", exact: true)
    end
  end

  scenario "unstock article on article show page" do
    user.stock(article)
    visit article_path(article)

    within('article') do
      click_link I18n.t("articles.unstock")
      expect(page).to have_link I18n.t("articles.stock")
      expect(page).to have_link("0", exact: true)
      within('.stock-users') do
        expect(page).not_to have_selector("img[src*='#{user.gravatar}']")
      end
    end
  end

  scenario "unstock article on article list page" do
    user.stock(article)
    visit articles_path

    within('article') do
      click_link("1", exact: true)
      expect(page).to have_link("0", exact: true)
    end
  end


end
