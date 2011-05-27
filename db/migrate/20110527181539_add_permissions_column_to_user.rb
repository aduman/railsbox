class AddPermissionsColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :can_hotlink, :boolean
    add_column :users, :is_admin, :boolean
  end

  def self.down
    remove_column :users, :is_admin
    remove_column :users, :can_hotlink
  end
end
