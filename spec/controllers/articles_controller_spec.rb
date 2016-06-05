require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let!(:user) { FactoryGirl.create(:user, :with_following_tag) }
  let!(:new_article) { FactoryGirl.create(:article) }
  let!(:stocked_article) do
    FactoryGirl.create(:article, :with_stock, user_id: user.id)
  end
  let!(:tagged_article) { FactoryGirl.create(:article, :with_tag) }
  let!(:drafting_article) { FactoryGirl.create(:draft, user_id: user.id) }

  before do
    sign_in user
    # read(for saving to database)
  end

  describe 'index' do
    subject { get :index }
    let(:result) do
      [tagged_article, stocked_article, new_article]
    end

    it '@articles have ordered 4 articles.' do
      subject
      expect(assigns(:articles).size).to eq result.size
      expect(assigns(:articles).to_a).to eq result
    end
  end

  describe 'feed' do
    subject { get :feed }
    let(:result) { [tagged_article] }

    it '@articles is only articles within the following tags.' do
      subject
      expect(assigns(:articles).to_a).to eq result
    end
  end

  describe 'draft' do
    subject { get :draft }
    let(:result) { [drafting_article] }

    it '@articles is only drafting articles.' do
      subject
      expect(assigns(:articles).to_a).to eq result
    end
  end

  describe 'stocked' do
    subject { get :stocked }
    let(:result) { [stocked_article] }

    it '@articles is only stocked articles.' do
      subject
      expect(assigns(:articles).to_a).to eq result
    end
  end

  describe 'owned' do
    subject { get :owned, params: { user_id: user.id } }
    let(:result) { [drafting_article, stocked_article] }

    it '@articles is only owned articles.' do
      subject
      expect(assigns(:articles).to_a).to eq result
    end
  end

  describe 'tagged' do
    subject { get :tagged, tag: 'tag' }
    let(:result) { [tagged_article] }

    it '@articles is only specified tagged articles.' do
      subject
      expect(assigns(:articles).to_a).to eq result
    end
  end

  describe 'show' do
    subject { get :show, id: stocked_article.id }
    let(:article_result) { stocked_article }
    let(:stocked_users_result) { [user] }

    it '@article is article by specified id.' do
      subject
      expect(assigns(:article)).to eq article_result
    end

    it_title = [
      'Number of @stocked_users is',
      'count of stocked users in article by specified id.'
    ].join(' ')
    it it_title do
      subject
      expect(assigns(:stocked_users).to_a).to eq stocked_users_result
    end
  end

  describe 'preview' do
    subject { post :preview, body: '# hoge', format: :js }
    let(:result) { %r{\A<h1>.*hoge.*</h1>\z}m }

    it 'Response body is converted heading text of html.' do
      subject
      expect(response.body.strip).to match result
    end
  end

  describe 'new' do
    subject { get :new }
    let(:result) { Article }

    it '@article is skeleton of Article.' do
      subject
      expect(assigns(:article)).to be_a_kind_of result
      expect(assigns(:article).id).to be_nil
    end
  end

  describe 'edit' do
    subject { get :edit, id: new_article.id }
    let(:result) { new_article }

    it '@article is article by specified id.' do
      subject
      expect(assigns(:article)).to eq result
    end
  end

  describe 'create' do
    let(:new_article_attributes) do
      {
        user_id: user.id,
        title: 'created_article_foo',
        body: '# foo',
        published: true,
        lock_version: 0,
        is_public_editable: true
      }
    end
    subject { post :create, article: new_article_attributes }

    it "@article's attributes is same specified values of parameter." do
      subject
      expect(assigns(:article)).to have_attributes new_article_attributes
    end
  end

  describe 'update' do
    let(:new_body) { '# bar' }
    context 'owned article' do
      subject do
        patch :update, id: stocked_article.id, article: { body: new_body }
      end
      it %(@article's body is updated to "# bar".) do
        subject
        expect(assigns(:article).errors.size).to be 0
        expect(assigns(:article).body).to eq new_body
      end
    end
    context 'unowned article' do
      subject do
        patch :update, id: new_article.id, article: { body: new_body }
      end
      it 'Redirect to articles_path' do
        subject
        expect(subject).to redirect_to :articles
      end
    end
  end

  describe 'destroy' do
    context 'owned article' do
      subject { delete :destroy, id: stocked_article.id }
      it 'Decrement to the number of articles.' do
        expect { subject }.to change(Article, :count).by(-1)
      end
    end
    context 'unowned article' do
      subject { delete :destroy, id: new_article.id }
      it 'Redirect to articles_path' do
        subject
        expect(subject).to redirect_to :articles
      end
    end
  end

  describe 'stock' do
    subject { post :stock, id: new_article.id, format: :js }
    let(:stockes_count) { 1 }

    it '' do
      subject
      expect(assigns(:article).stocks.size).to eq stockes_count
    end
  end

  describe 'unstock' do
    subject { post :unstock, id: stocked_article.id, format: :js }
    let(:stockes_count) { 0 }

    it '' do
      subject
      expect(assigns(:article).stocks.size).to eq stockes_count
    end
  end
end
