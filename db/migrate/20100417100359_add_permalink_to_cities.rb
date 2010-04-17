class AddPermalinkToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :permalink, :string
  end

  def self.down
    remove_column :cities, :permalink
  end
end
