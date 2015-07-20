class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.integer :user_id, :null => false 
      t.integer :bother_id, :null => false 

      t.timestamps null: false
    end
  end
end
