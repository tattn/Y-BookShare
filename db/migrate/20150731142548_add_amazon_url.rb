class AddAmazonUrl < ActiveRecord::Migration
  def change
    add_column :books, :amazon_url, :string, :default => ""
  end
end
