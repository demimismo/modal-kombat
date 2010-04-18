class CitiesController < ApplicationController

  def index
    respond_to do |format|
      format.js { @cities = City.all :select => 'name, id', :order => 'name asc' }
      format.html {
        @pedestrian_rank = Dataset.find :all, :order => 'pedestrian_share desc', :conditions => 'year = 2006', :limit => 10
        @car_rank = Dataset.find :all, :order => 'motorized_share desc', :conditions => 'year = 2006', :limit => 10
        @bike_rank = Dataset.find :all, :order => 'bike_share desc', :conditions => 'year = 2006', :limit => 10
        @bus_rank = Dataset.find :all, :order => 'public_transport_share desc', :conditions => 'year = 2006', :limit => 10
      }
    end
  end

  def show
    @city = City.slugged_find params[:id]
    last_dataset = @city.datasets.last
    @related_cities = Dataset.find :all, :conditions => [
      'city_id != ? and year = ? and population between ? and ?',
      @city.id,
      last_dataset.year,
      last_dataset.population.to_i - 2000,
      last_dataset.population.to_i + 2000
    ]
  end

  def versus
    @city1 = City.slugged_find params[:id].split('-versus-')[0]
    @city2 = City.slugged_find params[:id].split('-versus-')[1]
  end
end
