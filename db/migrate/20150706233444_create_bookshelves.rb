class CreateBookshelves < ActiveRecord::Migration
  def change
    create_table :bookshelves do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :borrower_id
      t.integer :rate

      t.timestamps null: false
    end
  end
end
