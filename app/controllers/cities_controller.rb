class CitiesController < ApplicationController

  def index
    @cities = City.all :select => 'name, id'
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
