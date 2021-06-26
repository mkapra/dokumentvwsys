class MakeUserMailNotUnique < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, :email
    change_column :users, :email, :string, unique: false
  end
end
