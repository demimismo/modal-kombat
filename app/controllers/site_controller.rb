class SiteController < ApplicationController
  def index
    if !params[:city1].blank? and !params[:city2].blank?
      redirect_to "/#{sluggify(params[:city1])}-versus-#{sluggify(params[:city2])}"
      return
    end

    @pedestrian_rank = Dataset.find :all, :order => 'pedestrian_share desc', :conditions => 'year = 2006'
    @pedestrian_rank = @pedestrian_rank.select { |v| v.city.country == 'España' }[0..2]

    @car_rank = Dataset.find :all, :order => 'motorized_share desc', :conditions => 'year = 2006'
    @car_rank = @car_rank.select { |v| v.city.country == 'España' }[0..2]

    @bike_rank = Dataset.find :all, :order => 'bike_share desc', :conditions => 'year = 2006'
    @bike_rank = @bike_rank.select { |v| v.city.country == 'España' }[0..2]

    @bus_rank = Dataset.find :all, :order => 'public_transport_share desc', :conditions => 'year = 2006'
    @bus_rank = @bus_rank.select { |v| v.city.country == 'España' }[0..2]
  end

  def about
    
  end


        def sluggify(text)
          return nil if text.blank?
          if defined?(Unicode)
            str = Unicode.normalize_KD(text).gsub(/[^\x00-\x7F]/n,'')
            str = str.gsub(/\W+/, '-').gsub(/^-+/,'').gsub(/-+$/,'').downcase
            return str
          else
            str = Iconv.iconv('ascii//translit', 'utf-8', text).to_s
            str.gsub!(/\W+/, ' ')
            str.strip!
            str.downcase!
            str.gsub!(/\ +/, '-')
            return str
          end
        end
end
