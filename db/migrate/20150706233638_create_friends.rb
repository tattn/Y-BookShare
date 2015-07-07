class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id, :null => false 
      t.integer :friend_id, :null => false 
      t.boolean :accepted, :null => false 

      t.timestamps null: false
    end
  end
end
