class AddBinaryToPreference < ActiveRecord::Migration[6.1]
  def change
    add_column :preferences, :is_file, :boolean, default: false
    add_column :preferences, :file, :binary
  end
end
