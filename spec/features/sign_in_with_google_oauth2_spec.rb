# -*- coding: utf-8 -*-
describe 'GoogleOauthでの認証' do
  before do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      :provider => user.provider,
      :uid => user.uid,
      :info => {
        :name => user.name,
        :email => user.email,
      },
      :credentials => {
        :token => 'CREDENTIAL_TOKEN'
      }
    )
    OmniAuth.config.test_mode = true
  end
  after { OmniAuth.config.test_mode = false }

  let(:user) do
    User.create(
      provider: 'google_oauth2',
      uid: 99999,
      email: 'test@gmail.com',
      name: 'USER NAME',
      password: 'mail-password',
      confirmed_at: Time.now,
    )
  end

  describe 'Google OAuth2による認証' do
    it 'Google Accountsでログイン／ログアウトできる' do
      visit root_path

      expect(page).to have_link('ログイン')
      expect(page).to have_link('Sign in with Google Oauth2')
      click_link 'Sign in with Google Oauth2'

      expect(page).to have_link('ログアウト')
      click_link 'ログアウト'

      expect(page).to have_link('ログイン')
    end
  end
end
