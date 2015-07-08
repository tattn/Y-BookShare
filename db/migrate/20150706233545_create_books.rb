class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, :null => false
      t.integer :genre_id, :null => true
      t.timestamps null: false
    end
  end
end
