class GeocodeCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :lat, :string
    add_column :cities, :lng, :string
    add_column :cities, :country, :string
  end

  def self.down
    remove_column :cities, :lat, :lng, :country
  end
end
