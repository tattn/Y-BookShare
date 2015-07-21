class CreateBookshelves < ActiveRecord::Migration
  def change
    create_table :bookshelves do |t|
      t.integer :user_id, :null => false 
      t.integer :book_id, :null => false 
      t.integer :borrower_id, :null => false 
      t.integer :rate
      t.string  :comment

      t.timestamps null: false
    end
  end
end
