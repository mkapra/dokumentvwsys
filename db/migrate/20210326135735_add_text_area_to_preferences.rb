class AddTextAreaToPreferences < ActiveRecord::Migration[6.1]
  def change
    add_column :preferences, :is_textarea, :boolean, default: false
  end
end
