
class Route
  attr_reader :stations

  def initialize(initial_station, final_station)
    if initial_station.is_a?(Station) && final_station.is_a?(Station)
      @stations = [initial_station, final_station]
    else
      raise "instances of class Station must compose the route"
    end
  end

  def add_station(stn)
    stations.insert(-2, stn) if stn.is_a?(Station)
  end

  def delete_station(stn)
    stations.delete(stn)
  end

  def list_stations
    stations.map(&:to_s)
  end

  def to_s
    list_stations.inspect
  end
end
