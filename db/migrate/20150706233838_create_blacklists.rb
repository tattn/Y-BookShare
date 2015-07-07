class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.integer :user_id
      t.integer :botheer_id

      t.timestamps null: false
    end
  end
end
