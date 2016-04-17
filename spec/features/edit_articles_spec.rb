require 'rails_helper'

feature 'Edit articles', type: :feature do
  shared_examples_for 'Update article and notify stocked user' do
    scenario 'Update article and notify stocked user' do
      visit edit_article_path(article)

      new_tags = %w(tag0 tag1 tag2 tag3 tag4 tag5 tag6 tag7 tag8 tag9)
      new_title = 'new article'
      new_body = 'body'
      fill_in I18n.t('activerecord.attributes.article.title'), with: new_title
      fill_in_autocomplete('#article_tag_list', new_tags.join(','))
      fill_in I18n.t('activerecord.attributes.article.body'), with: new_body
      click_button I18n.t('helpers.submit.update')

      expect(page).to have_content(new_title)
      new_tags.each do |tag|
        expect(page).to have_link(tag, href: tagged_articles_path(tag: tag))
      end
      expect(page).to have_content('body')

      within '.article-header-area' do
        click_link "(#{article.update_histories.size})" # Go to update history
      end
      expect(page).to have_content(
        I18n.t('update_histories.current_article', article_title: new_title)
      )

      first(:link, new_title).click
      expect(page).to have_content(
        I18n.t('update_histories.current_article', article_title: new_title)
      )
      expect(page).to have_content('-old article')
      expect(page).to have_content("+#{new_title}")
      expect(page).to have_content('-old_tag')
      expect(page).to have_content("+#{new_tags.join(', ')}")
      expect(page).to have_content('-old body')
      expect(page).to have_content("+#{new_body}")
      logout

      login_as stocked_user, scope: :user
      visit root_path
      find('#num-of-notification').click # TODO: to write more declarative
      expect(page).to have_content(
        I18n.t(
          'common.notification.article_update',
          user_name: user.name, article_title: new_title
        )
      )
    end
  end

  context 'when public article' do
    let(:article) do
      FactoryGirl.create(
        :article, title: 'old article', tag_list: 'old_tag', body: 'old body'
      )
    end
    let(:stocked_user) { FactoryGirl.create(:user) }
    background do
      stocked_user.stock(article)
      login_as user, scope: :user
    end

    context 'by owner' do
      let(:user) { article.user }
      it_behaves_like 'Update article and notify stocked user'
    end

    context 'by not owner' do
      let(:user) { FactoryGirl.create(:user) }
      it_behaves_like 'Update article and notify stocked user'
    end
  end

  context 'when private article' do
    let(:article) do
      FactoryGirl.create(
        :article,
        title: 'old article', tag_list: 'old_tag', body: 'old body',
        is_public_editable: false
      )
    end
    let(:stocked_user) { FactoryGirl.create(:user) }

    background do
      stocked_user.stock(article)
      login_as user, scope: :user
    end

    context 'by owner' do
      let(:user) { article.user }
      it_behaves_like 'Update article and notify stocked user'
    end

    context 'by not owner' do
      let(:user) { FactoryGirl.create(:user) }
      scenario 'Redirect to article list page' do
        visit edit_article_path(article)
        expect(current_path).to eq articles_path
      end
    end
  end

  context 'when multiple articles' do
    let(:article1_attrs) do
      { title: 'old article1', tag_list: '1', body: 'old body' }
    end
    let(:article2_attrs) do
      { title: 'old article2', tag_list: '2', body: 'old body' }
    end
    let(:article1) { FactoryGirl.create(:article, article1_attrs) }
    let(:article2) { FactoryGirl.create(:article, article2_attrs) }

    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    background do
      article1.update(update_user_id: user1.id)
      article2.update(update_user_id: user2.id)
      login_as user1, scope: :user
    end

    scenario 'Update articles for each other users' do
      visit article_path(article1)
      within '.article-detail-area' do
        expect(find('.updated-by')).to have_content user1.name
      end

      visit article_path(article2)
      within '.article-detail-area' do
        expect(find('.updated-by')).to have_content user2.name
      end
    end
  end
end
