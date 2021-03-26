# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include AdministrationHelper

    skip_before_action :require_no_authentication
    before_action :verify_admin_user, only: %i[new create cancel]

    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # POST /resource
    def create
      password_length = 8
      password = Devise.friendly_token.first(password_length)
      params[:user][:password] = password
      params[:user][:password_confirmation] = password
      new_user = User.new(user_params)
      return redirect_to new_administration_path, flash: { error: 'Error while creating the user' } unless new_user.save

      render pdf: 'login', template: "devise/registrations/pdf.html.erb", disposition: 'attachment', encoding: 'utf-8'
    end

    protected

    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :birth, :password, :password_confirmation,
                                   :email, :role_id)
    end
  end
end
