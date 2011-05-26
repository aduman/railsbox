class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :assigned_by
      t.boolean :read_perms, :default => false
      t.boolean :write_perms, :default => false
      t.boolean :delete_perms, :default => false
      t.integer :folder_id      

      t.integer :parent_id
      t.string :parent_type
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
