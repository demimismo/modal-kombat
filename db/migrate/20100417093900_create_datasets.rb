class CreateDatasets < ActiveRecord::Migration
  def self.up
    create_table :datasets do |t|
      t.references :city
      t.integer :year
      t.integer :population
      t.float :bike_share
      t.float :motorized_share
      t.float :public_transport_share
      t.float :pedestrian_share

      t.timestamps
    end
  end

  def self.down
    drop_table :datasets
  end
end
