class AdministrationController < ApplicationController
  include AdministrationHelper

  before_action :authenticate_user!
  before_action :verify_admin_user

  def index
    @users = User.all
  end

  def new
    @user = User.new
    return unless params[:user]

    split_name = params[:user].split(' ')
    @user.first_name = split_name[0]
    @user.last_name = if split_name.length > 2
                        split_name[1, split_name.length]
                      else
                        split_name[1]
                      end
  end

  def edit
    raise ActionController::RoutingError, 'Not found'
  end

  def show
    @user = User.find(params[:id])
    password_length = 8
    password = Devise.friendly_token.first(password_length)
    @user.password = password
    @user.password_confirmation = password
    @user.save!

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'login',
        template: "devise/registrations/pdf.html.erb",
        disposition: 'attachment',
        encoding: 'utf-8',
        locals: {password: password}
      end
    end
    @user.downloaded = true
    @user.save!
  end

  def destroy
    if params[:id].to_i == current_user.id
      return redirect_to administration_index_path,
                         flash: { error: 'Cannot delete yourself' }
    end

    User.find(params[:id]).destroy
    flash[:notice] = t('message.notice.delete_user')
    redirect_to action: 'index'
  rescue ActiveRecord::RecordNotFound
    redirect_to action: 'index', flash: { error: 'User not found' }
  end
end
