class CreateGenrelists < ActiveRecord::Migration
  def change
    create_table :genrelists do |t|
      t.integer :user_id, :null => false 
      t.integer :genre_id, :null => false 

      t.timestamps null: false
    end
  end
end
