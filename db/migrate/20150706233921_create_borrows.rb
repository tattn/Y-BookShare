class CreateBorrows < ActiveRecord::Migration
  def change
    create_table :borrows do |t|
      t.integer :user_id, :null => false 
      t.integer :book_id, :null => false 
      t.integer :lender_id, :null => false 
      t.datetime :due_date

      t.timestamps null: false
    end
  end
end
