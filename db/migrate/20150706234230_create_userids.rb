class CreateUserids < ActiveRecord::Migration
  def change
    create_table :userids do |t|
      t.integer :user_id, :null => false 

      t.timestamps null: false
    end
  end
end
