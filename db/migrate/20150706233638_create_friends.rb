class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.integer :friend_id
      t.bool :accepted

      t.timestamps null: false
    end
  end
end
