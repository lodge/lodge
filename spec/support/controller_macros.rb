module ControllerMacros
  def sign_in
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @login_user = FactoryGirl.create(:user)
      sign_in @login_user
    end
  end
end
