class AdministrationController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin_user

  def index
    @users = User.all
    @user = User.new
  end

  def new
    @user = User.new
  end

  def edit; end

  def create; end

  def destroy
    if params[:id].to_i == current_user.id
      redirect_to administration_index_path,
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
end
