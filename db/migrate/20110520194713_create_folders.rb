class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :folders, :parent_id  
  end

  def self.down
    drop_table :folders
  end
end
