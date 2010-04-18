class SiteController < ApplicationController
  def index
    if !params[:city1].blank? and !params[:city2].blank?
      redirect_to "/#{params[:city1].downcase}-versus-#{params[:city2].downcase}"
      return
    end

    @pedestrian_rank = Dataset.find :all, :order => 'pedestrian_share desc', :conditions => 'year = 2006'
    @pedestrian_rank = @pedestrian_rank.select { |v| v.city.country == 'España' }[0..2]

    @car_rank = Dataset.find :all, :order => 'motorized_share desc', :conditions => 'year = 2006'
    @car_rank = @car_rank.select { |v| v.city.country == 'España' }[0..2]
  end
end
