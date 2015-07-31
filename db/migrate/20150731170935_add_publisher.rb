class AddPublisher < ActiveRecord::Migration
  def change
    add_column :books, :publisher, :string, :default => ""
  end
end
