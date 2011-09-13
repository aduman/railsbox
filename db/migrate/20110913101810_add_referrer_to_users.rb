class AddReferrerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :referrer, :string
  end

  def self.down
    remove_column :users, :referrer
  end
end
