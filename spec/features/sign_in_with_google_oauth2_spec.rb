# -*- coding: utf-8 -*-
require 'rails_helper'

describe 'GoogleOauthでの認証', :type => :feature do
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
    # TODO もうちょっと丁寧に修正する。
    unless ENV["GOOGLE_CLIENT_ID"].blank?
      it 'Google Accountsでログイン／ログアウトできる' do
        visit root_path

        message_sign_in = I18n.t("common.sign_in")
        message_sign_out = I18n.t("users.logout")
        message_sign_in_with = I18n.t("common.sign_in_with", provider: 'Google Oauth2')
        expect(page).to have_link(message_sign_in)
        expect(page).to have_link(message_sign_in_with)
        click_link message_sign_in_with

        find(".glyphicon-cog").click
        expect(page).to have_link(message_sign_out)
        click_link message_sign_out

        expect(page).to have_link(message_sign_in)
      end
    end
  end
end
