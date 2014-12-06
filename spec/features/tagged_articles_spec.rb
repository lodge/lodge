require 'rails_helper'

feature "TaggedArticles", :type => :feature do
  let(:tag) { 'foo.bar' }
  let(:article) { FactoryGirl.create(:article, tag_list: tag) }

  background do
    login_as FactoryGirl.create(:user)
  end

  scenario "access to articles tagged abnormal page" do
    visit article_path(article)
    find('article')
    within 'article' do
      click_link tag
    end
    expect(page).to have_content(I18n.t('articles.list_title_by_tag', tag: tag))
    expect(page).to have_content(article.title)
  end
end
