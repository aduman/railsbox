class AddAhcContactToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :AHC_contact, :string
  end

  def self.down
    remove_column :users, :AHC_contact
  end
end
