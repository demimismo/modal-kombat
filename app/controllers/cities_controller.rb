class CitiesController < ApplicationController
  def show
    @city = City.slugged_find params[:id]
  end

  def versus
    @city1 = City.slugged_find params[:id].split('-versus-')[0]
    @city2 = City.slugged_find params[:id].split('-versus-')[1]
  end
end
