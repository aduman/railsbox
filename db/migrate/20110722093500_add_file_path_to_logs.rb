class AddFilePathToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :file_path, :string
  end

  def self.down
    remove_column :logs, :file_path
  end
end
