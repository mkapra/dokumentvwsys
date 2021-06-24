module AdministrationHelper
  def verify_admin_user
    return redirect_to new_user_session_path if current_user.nil?

    redirect_to errors_not_found_path unless current_user.admin?
  end
end
