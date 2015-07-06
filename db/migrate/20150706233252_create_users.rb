class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :school
      t.integer :lend_num
      t.integer :borrow_num
      t.string :invitation_code

      t.timestamps null: false
    end
  end
end
