class AddIcon < ActiveRecord::Migration
  def change
    add_column :users, :icon_name, :string, :default => ""
    add_column :users, :icon_data, :binary, :limit => 10.megabytes
  end
end
