include Geokit::Geocoders

class City < ActiveRecord::Base
  has_slug :source_column => :name, :slug_column => :permalink, :prepend_id => false
  has_many :datasets
  acts_as_mappable

  def geocode!
    geo = Geokit::Geocoders::MultiGeocoder.geocode(self.name)
    if geo.success
      self.lat, self.lng = geo.lat, geo.lng
      self.name, self.country = geo.city, geo.country
    end
    self.save
  end
end
