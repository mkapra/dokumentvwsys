class AdministrationController < ApplicationController
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

  def edit; end

  def destroy
    if params[:id].to_i == current_user.id
      return redirect_to administration_index_path,
                  flash: { error: 'Cannot delete yourself' }
    end

    User.find(params[:id]).destroy
    flash[:notice] = 'User deleted successfully'
    redirect_to action: 'index'
  rescue ActiveRecord::RecordNotFound
    redirect_to action: 'index', flash: { error: 'User not found' }
  end

  def verify_admin_user
    redirect_to root_path, flash: { error: 'Not allowed' } unless current_user.admin?
  end

  def resource_name
    :user
  end
end
