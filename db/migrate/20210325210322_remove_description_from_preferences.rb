class RemoveDescriptionFromPreferences < ActiveRecord::Migration[6.1]
  def change
    remove_column :preferences, :description
  end
end
