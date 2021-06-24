class CreatePreferences < ActiveRecord::Migration[6.1]
  def change
    create_table :preferences do |t|
      t.string :key
      t.string :value
      t.string :group
      t.string :description

      t.timestamps
    end
  end
end
