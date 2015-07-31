class AddPublicationDate < ActiveRecord::Migration
  def change
    add_column :books, :publication_date, :date, :default => nil
  end
end
