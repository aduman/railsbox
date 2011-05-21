class AddDescriptionsAndNotes < ActiveRecord::Migration
  def self.up
    add_column(:folders, :description, :text)
    add_column(:assets, :description, :text)
    add_column(:folders, :notes, :text)
    add_column(:assets, :notes, :text)
  end

  def self.down
    remove_column(:folders, :description)
    remove_column(:assets, :description)
    remove_column(:folders, :notes)
    remove_column(:assets, :notes)
  end
end
