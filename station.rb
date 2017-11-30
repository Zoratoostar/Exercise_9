
class Station
  extend Accessors
  include Validation

  attr_reader :trains
  attr_accessor_with_history :name

  validate :name, :presence
  validate :name, :format, /[А-Яa-z]{3,}/i
  validate :name, :type, String

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    self.name = name
    validate!
    @trains = []
    @@stations << self
  end

  def receive_train(trn)
    if trn.is_a?(Train) && !trains.include?(trn)
      trains << trn
      trn
    end
  end

  def send_train(trn)
    trains.delete(trn)
  end

  def passenger_trains
    trains.select { |trn| trn.is_a?(PassengerTrain) }
  end

  def freight_trains
    trains.select { |trn| trn.is_a?(CargoTrain) }
  end

  def list_all_trains
    trains.map(&:to_s)
  end

  def list_passenger_trains
    passenger_trains.map(&:to_s)
  end

  def list_freight_trains
    freight_trains.map(&:to_s)
  end

  def each_train(&block)
    trains.each_with_index(&block)
  end

  def to_s
    name
  end
end
