class AddUserIdToAssetsAndFolders < ActiveRecord::Migration
  def self.up
      add_column(:assets, :user_id, :integer)
      add_column(:folders, :user_id, :integer)
  end

  def self.down
      remove_column(:assets, :user_id)
      remove_column(:folders, :user_id)
  end
end
