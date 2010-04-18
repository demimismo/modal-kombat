class Dataset < ActiveRecord::Base
  belongs_to :city

  # calculo el parámetro que falta en caso de que falte sólo uno, hay varios así
  def before_save
    modes = ['pedestrian_share', 'motorized_share', 'public_transport_share', 'bike_share']

    modes.each do |mode|
      modes2 = modes - [mode]
      # si el valor actual es nil y el resto de valores no lo son...
      if eval("self.#{mode}").nil? and modes2.delete_if { |met| eval("self.#{met}.nil?") }.size == 3
        sum = 0
        modes2.each { |meth| sum += eval("self.#{meth}") }
        eval("self.#{mode} = 100.0 - sum")
      end
    end
  end

  def bike_rank
    Dataset.count :conditions => ['city_id != ? and bike_share >= ?', self.id, self.bike_share], :order => 'bike_share desc'
  end
  def pedestrian_rank
    Dataset.count :conditions => ['city_id != ? and pedestrian_share >= ? and year = ?', self.id, self.pedestrian_share, self.year], :order => 'pedestrian_share desc'
  end
  def motorized_rank
    Dataset.count :conditions => ['city_id != ? and motorized_share >= ? and year = ?', self.id, self.motorized_share, self.year], :order => 'motorized_share desc'
  end
  def public_transport_rank
    Dataset.count :conditions => ['city_id != ? and public_transport_share >= ? and year = ?', self.id, self.public_transport_share, self.year], :order => 'public_transport_share desc'
  end
end
