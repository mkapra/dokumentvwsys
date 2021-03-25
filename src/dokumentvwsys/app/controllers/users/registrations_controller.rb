# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :require_no_authentication
    before_action :check_permission, only: %i[new create cancel]

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

      pdf = WickedPdf.new.pdf_from_string(pdf_string)
      send_data pdf, :filename => "#{new_user.full_name.split(" ").join("_").downcase}.pdf", :type => "application/pdf"
      #redirect_to new_administration_path, flash: { notice: 'User created successfully' }
    end

    protected

    def pdf_string
      render_to_string(template:'devise/registrations/pdf.html.erb', encoding: 'utf8',  disposition: 'attachment', page_size: 'A4', layout: false)
    end

    def check_permission
      return redirect_to root_path, flash: { error: 'Not authorized' } if current_user.nil?

      redirect_to root_path, flash: { error: 'Not authorized' } unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :birth, :password, :password_confirmation,
                                   :email, :role_id)
    end
  end
end
