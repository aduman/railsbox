class CreateHotlinks < ActiveRecord::Migration
  def self.up
    create_table :hotlinks do |t|
      t.integer :asset_id
      t.string :password_hash
      t.string :password_salt
      t.string :link
      t.datetime :expiry_date
      t.string :password
      t.timestamps
    end
  end

  def self.down
    drop_table :hotlinks
  end
end
