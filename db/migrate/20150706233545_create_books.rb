class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, :null => false
      t.integer :isbn, :limit =>8        # 10桁必要なので bigint 型を利用
			t.string :author
			t.string :manufacturer
      t.integer :genre_id, :null => true
      t.timestamps null: false
    end
  end
end
