class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :user_id, :null => false
      t.string :email, :null => false
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.string :school, :defaut => ''
      t.integer :lend_num, :default => 0
      t.integer :borrow_num, :default => 0
			t.string :comment, :default => ''
      t.string :invitation_code, :null => false
	    t.string :password_digest

      t.timestamps null: false
    end
    add_index :users, :user_id, :unique => true
  end
end
