require 'fastercsv'

namespace :modal_kombat do
  desc "Importar todos los datos"
  task :load_data  => :environment do
    Dir[RAILS_ROOT+'/db/data/*.csv'].each do |csv_file|
      FasterCSV.open(csv_file).each do |row|
        next unless row[0].is_a?(String) and row[2] != 'CITIES_LAB'
        city = City.find_or_create_by_name row[2]
        year = row[0].split('_')[1]
        next unless year.to_i > 1900
        dataset = city.datasets.find_or_create_by_year year
        case row[1]
          when 'Total population in Urban Audit cities' then dataset.population = row[5].to_f
          when 'Proportion of journeys to work by bicycle' then dataset.bike_share = row[5].to_f
          when 'Proportion of journeys to work by car or motor cycle' then dataset.motorized_share = row[5].to_f
          when 'Proportion of journeys to work by public transport (rail, metro, bus, tram)' then dataset.public_transport_share = row[5].to_f
          when 'Proportion of journeys to work by foot' then dataset.pedestrian_share = row[5].to_f
        else puts "Dato sin localizar: #{row[1]}"
        end
        dataset.save
      end
    end
  end
end


#namespace :modal_kombat do
#  desc "Importar todos los datos"
#  task :load_data  => :environment do
#    Dir[RAILS_ROOT+'/db/data/*.csv'].each do |csv_file|
#      Excelsior::Reader.rows(File.open(Dir[RAILS_ROOT+'/db/data/*.csv'][0]), 'rb') do |row|
#        puts '-----'
#        puts row[2]
#        puts row[1]
#        puts row[0].split('_')[1]
#        puts row[5]
#        puts ''
#      end
#    end
#  end
#end
#
#
