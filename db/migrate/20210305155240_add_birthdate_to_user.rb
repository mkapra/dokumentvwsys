class AddBirthdateToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :birth, :date
  end
end
