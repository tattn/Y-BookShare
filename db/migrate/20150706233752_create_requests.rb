class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id, :null => false 
      t.integer :sender_id, :null => false 
      t.integer :book_id, :null => false 
      t.boolean :accepted

      t.timestamps null: false
    end
  end
end
