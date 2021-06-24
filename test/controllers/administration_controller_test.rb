require 'test_helper'

class AdministrationControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should redirect to 404 for normal user on admin sites' do
    sign_in users(:user_franz)

    # GET /administration
    get administration_index_path
    assert_redirected_to errors_not_found_path, 'Normal user was able to access list of users'

    # GET /administration/new
    get new_administration_path
    assert_redirected_to errors_not_found_path, 'Normal user was able to access create user form'

    # GET /administration/:id/edit
    get edit_administration_path(User.first.id)
    assert_redirected_to errors_not_found_path, 'Normal user was able to access edit user form'

    # POST /administration
    assert_no_difference 'User.count', 'No User should be created' do
      post user_registration_path, params: { user: User.first.clone }
    end
    assert_redirected_to errors_not_found_path, 'Normal user was able to execute a POST request'

    # DELETE /administration/:id
    assert_no_difference 'User.count', 'No User should be deleted' do
      delete administration_path(User.first.id)
    end
    assert_redirected_to errors_not_found_path, 'Normal user was able to execute a DELETE request'
  end

  test 'should redirect to login_site for not logged in users' do
    # GET /administration
    get administration_index_path
    assert_redirected_to new_user_session_path, 'Not logged in user was able to access list of users'

    # GET /administration/new
    get new_administration_path
    assert_redirected_to new_user_session_path, 'Not logged in user was able to access create user form'

    # GET /administration/:id/edit
    get edit_administration_path(User.first.id)
    assert_redirected_to new_user_session_path, 'Not logged in user was able to access edit user form'

    # POST /administration
    assert_no_difference 'User.count', 'No User should be created' do
      post user_registration_path, params: { user: User.first.clone }
    end
    assert_redirected_to new_user_session_path, 'Not logged in user was able to execute a POST request'

    # DELETE /administration/:id
    assert_no_difference 'User.count', 'No User should be deleted' do
      delete administration_path(User.first.id)
    end
    assert_redirected_to new_user_session_path, 'Not logged in user was able to execute a DELETE request'
  end

  test 'should render all views correctly for administrator' do
    sign_in users(:user_administrator)

    # GET /administration
    get administration_index_path
    assert_response :success, 'Admin user could not access list of users'

    # GET /administration/new
    get new_administration_path
    assert_response :success, 'Admin user did not get form for new user'

    # GET /administration/:id/edit
    # get edit_administration_path(User.first.id)
    # assert_response :success, 'Admin user did not get form for edit user'

    # POST /administration
    assert_difference 'User.count', 1, 'No User could be created by admin' do
      user_attributes = User.first.attributes
      user_attributes[:email] = 'test@email.de'   # Needs to be unique
      user_attributes[:username] = 'new_username' # Needs to be unique

      post user_registration_path, params: { user: user_attributes }
    end
    assert_redirected_to new_administration_path, 'Admin user could not create user'
    assert_equal I18n.t('message.notice.create_user'), flash[:notice]

    # DELETE /administration/:id
    assert_difference 'User.count', -1, 'No User could be deleted by admin' do
      delete administration_path(User.first.id)
    end
    assert_equal I18n.t('message.notice.delete_user'), flash[:notice]
  end
end
