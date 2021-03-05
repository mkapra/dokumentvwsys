class AddUserToDocument < ActiveRecord::Migration[6.1]
  def change
    add_reference :documents, :user, index: true
  end
end
