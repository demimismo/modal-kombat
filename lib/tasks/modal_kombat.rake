require 'fastercsv'

namespace :modal_kombat do
  desc "Importar todos los datos"
  task :load_data  => :environment do
    Rake::Task["modal_kombat:load_icity"].invoke
    Rake::Task["modal_kombat:load_ikey"].invoke
    # Rake::Task["modal_kombat:geocode"].invoke
  end

  desc "Importar ficheros de índices extendidos (la mayor parte de datos)"
  task :load_icity  => :environment do
    STDOUT.sync = true
    puts 'Cargando icity...'
    Dir[RAILS_ROOT+'/db/data/*.csv'].each do |csv_file|
      FasterCSV.open(csv_file).each do |row|
        next unless row[0].is_a?(String) and !row[2].nil? and row[2] != 'CITIES_LAB'
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
        print '.'
      end
    end
  end

  desc "Importar datos de índices principales, para completar"
  task :load_ikey  => :environment do
    STDOUT.sync = true
    # La MIERDA de aplicación de la que me descargo los datos ha tenido este
    # detalle
    renaming = {
      'M?nchen' => 'München',
      'Kernel K?benhavn' => 'Kernel Kobenhavn',
      'Besan?on' => 'Besançon',
      'Ume?'=> 'Umeå',
      'Lens - Li?vin'=> 'Lens-Liévin',
      'Trenc?n'=> 'Trenčan',
      'Gij?n'=>'Gijón',
      'M?nchengladbach'=> 'Mönchengladbach',
      'Sz?kesfeh?rv?r'=> 'Szekesfehervar',
      'Kecskem?t'=> 'Kecskemét',
      'Pamplona/Iru?a'=> 'Pamplona/Iruña',
      'Orl?ans'=> 'Orleans',
      'N?rnberg'=> 'Nürnberg',
      'G?teborg'=> 'Göteborg',
      'Set?bal'=> 'Setúbal',
      'G?ttingen'=> 'Göttingen',
      'M?lheim a.d.Ruhr'=> 'Mülheim a.d.Ruhr',
      'K?benhavn'=> 'Copenhagen',
      'Link?ping'=> 'Linköping',
      'D?sseldorf'=> 'Düsseldorf',
      'Logro?o'=> 'Logroño',
      'J?nk?ping'=> 'Jönköping'
    }

    puts 'Cargando ikey...'
    Dir[RAILS_ROOT+'/db/data/ikey/*.csv'].each do |csv_file|
      FasterCSV.open(csv_file).each do |row|
        next unless row[0].is_a?(String) and row[2] != 'CITIES_LAB'
        city = City.find_by_name row[2]
        next unless city
        city.update_attribute('name', renaming[city.name]) unless renaming[city.name].blank?
        year = row[0].split('_')[1]
        next unless year.to_i > 1900
        dataset = city.datasets.find_or_create_by_year year
        next unless dataset.motorized_share.nil? or dataset.motorized_share <= 0
        dataset.motorized_share = row[5].to_f
        dataset.save
        print '.'
      end
    end
  end

  desc "Geolocalización de cada ciudad, por limpiar nombres y obtener países"
  task :geocode  => :environment do
    STDOUT.sync = true
    puts 'Geolocalizando ciudades...'
    City.all.each do |city|
      city.geocode!
      print '.'
    end
  end

  desc "Limpiar datasets chungos"
  task :clean  => :environment do
    STDOUT.sync = true
    puts 'Limpiando...'
    modes = ['pedestrian_share', 'motorized_share', 'public_transport_share', 'bike_share']
    Dataset.all.each do |data|
      modes.each do |m|
        data.destroy if eval("data.#{m}").nil?
      end
    end

    City.all.each { |c| c.destroy if c.datasets.blank? }
  end
end
