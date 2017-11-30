
class Train
  include ProducingCompany

  NUMBER_FORMAT = /[a-z\d]{3}-?[a-z\d]{2}/i

  attr_reader :unique_number, :route, :carriages
  attr_accessor :speed, :current_station_index
  protected :speed, :current_station_index

  @@trains = {}

  def self.find(uid)
    @@trains[uid.to_s]
  end

  def initialize(uid)
    @unique_number = uid.to_s
    validate!
    @carriages = []
    @speed = 0
    @@trains[unique_number] = self
  end

  def add_speed(amount)
    self.speed += amount
  end

  def stop
    self.speed = 0
  end

  def hitch_carriage(car)
    if speed.zero? && car.is_a?(Carriage)
      carriages << car
      car
    end
  end

  def unhook_carriage
    carriages.pop if speed.zero? && !carriages.empty?
  end

  def list_carriages
    carriages.map(&:to_s)
  end

  def each_carriage(&block)
    carriages.each_with_index(&block)
  end

  def assign_route(route)
    if route.is_a?(Route)
      @route = route
      self.current_station_index = 0
      current_station.receive_train(self)
    end
  end

  def shift_forward
    if next_station
      current_station.send_train(self)
      self.current_station_index += 1
      current_station.receive_train(self)
    end
  end

  def shift_backward
    if previous_station
      current_station.send_train(self)
      self.current_station_index -= 1
      current_station.receive_train(self)
    end
  end

  def current_station
    route.stations[current_station_index]
  end

  def to_s
    unique_number
  end

  def valid?
    validate!
  rescue RuntimeError
    false
  end

  protected

  def validate!
    raise "Номер поезда не может быть пустым." unless unique_number
    instruction = <<-TEXT
    Допустимый формат: три буквы или цифры в любом порядке,
    необязательный дефис (может быть, а может нет)
    и еще 2 буквы или цифры после дефиса.
    TEXT
    mresult = NUMBER_FORMAT.match(unique_number)
    raise instruction unless mresult && mresult[0].length == unique_number.length
    instruction = "Номер поезда должен быть уникальным."
    raise instruction if self.class.find(unique_number)
    true
  end

  def next_station
    route.stations[current_station_index + 1]
  end

  def previous_station
    route.stations[current_station_index - 1] if current_station_index > 0
  end
end
