class PreferencesController < ApplicationController
  def index
    @preferences = Preference.all.group_by(&:group)
  end

  def update
    preference = Preference.where(key: params[:preference][:key]).first
    preference.value = params[:preference][:value]
    return redirect_to preferences_path, flash: { error: t('message.error.save_settings') } unless preference.save

    redirect_to preferences_path, flash: { notice: t('message.success.save_settings') }
  end
end
