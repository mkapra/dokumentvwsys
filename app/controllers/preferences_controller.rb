# frozen_string_literal: true

class PreferencesController < ApplicationController
  include AdministrationHelper

  before_action :authenticate_user!, only: %i[index update]
  before_action :verify_admin_user, only: %i[index update]

  def index
    @preferences = Preference.all.group_by(&:group).sort
  end

  def update
    preference = Preference.where(key: params[:preference][:key]).first

    if preference.is_file && params[:preference][:file].nil?
      flash[:error] = I18n.t('error.empty_file')
      return redirect_to action: 'index'
    end

    if preference.is_file && params[:preference][:file] && (params[:preference][:file].content_type != 'image/png')
      flash['error'] = I18n.t('error.not_a_png')
      return redirect_to action: 'index'
    end

    if preference.is_file
      preference.file = params[:preference][:file].read
    else
      preference.value = params[:preference][:value]
    end
    return redirect_to preferences_path, flash: { error: t('error.save_settings') } unless preference.save

    redirect_to preferences_path, flash: { notice: t('message.success.save_settings') }
  end

  def logo
    send_data Preference.where(key: 'image').first.file, type: 'image/png', disposition: 'inline'
  end
end
