class CreateGenrelists < ActiveRecord::Migration
  def change
    create_table :genrelists do |t|
      t.integer :user_id
      t.integer :genre_id

      t.timestamps null: false
    end
  end
end
