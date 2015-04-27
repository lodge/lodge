require 'rails_helper'

feature 'TaggedArticles', type: :feature do
  let(:tag) { 'foo.bar' }
  let(:article) { FactoryGirl.create(:article, tag_list: tag) }
  let(:user) { article.user }

  background do
    login_as user, scope: :user
  end

# scenario 'access to articles tagged abnormal page' do
#   visit article_path(article)
#   find('article')
#   within 'article' do
#     link = find('a', text: tag)
#     # FIXME
#     # ap link.visible? # => true
#     # click_link tag
#   end
#   # expect(page).to have_content(I18n.t('articles.list_title_by_tag', tag: tag))
#   # expect(page).to have_content(article.title)
# end
end
