class AddSalesRank < ActiveRecord::Migration
  def change
    add_column :books, :salesrank, :integer, :default => -1
  end
end
