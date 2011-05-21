class AddFolderIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :folder_id, :integer
  end

  def self.down
    remove_column :assets, :folder_id
  end
end
