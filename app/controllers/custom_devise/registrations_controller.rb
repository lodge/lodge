class CustomDevise::RegistrationsController < Devise::RegistrationsController
  before_action :customize_sign_up_params, only: [:create, :update]

  def destroy
    @user.lock_access!
    redirect_to root_path
  end

  private

  def customize_sign_up_params
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:name, :email, :current_password, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:name, :email, :password, :password_confirmation)
    end
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

end
