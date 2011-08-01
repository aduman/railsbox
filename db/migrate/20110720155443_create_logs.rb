class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :user_id
      t.string :controller
      t.string :action
      t.string :parameters
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
