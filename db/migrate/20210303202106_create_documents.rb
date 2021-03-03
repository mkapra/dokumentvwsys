class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.binary :pdf, null: false
      t.string :filename, null: false
      t.date :delete_at, null: false

      t.timestamps
    end
  end
end
