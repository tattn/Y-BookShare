class CreateBorrows < ActiveRecord::Migration
  def change
    create_table :borrows do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :lender_id
      t.datetime :due_date

      t.timestamps null: false
    end
  end
end
