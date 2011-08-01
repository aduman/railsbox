class AddTargetIdToLog < ActiveRecord::Migration
  def self.up
    add_column :logs, :target_id, :string
  end

  def self.down
    remove_column :logs, :target_id
  end
end
