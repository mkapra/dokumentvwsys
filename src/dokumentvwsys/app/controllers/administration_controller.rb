class AdministrationController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin_user

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
  end

  def verify_admin_user
    redirect_to root_path, flash: { error: "Not allowed" } unless current_user.admin?
  end
end
