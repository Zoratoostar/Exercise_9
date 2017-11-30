
class FreightWagon < Carriage
  attr_reader :purpose
  attr_reader :capacity
  attr_reader :filled_capacity

  self.instances = 0

  def initialize(number, purpose, capacity)
    super(number)
    @purpose = purpose.to_s
    @capacity = capacity.to_i
    validate!
    @filled_capacity = 0
  end

  def fill_in_capacity(value)
    @filled_capacity += value if filled_capacity + value <= capacity
  end

  def available_capacity
    capacity - filled_capacity
  end

  def to_s
    "#{number}=#{purpose}=#{capacity} => #{available_capacity}"
  end

  protected

  def validate!
    super
    raise "Назначение вагона должно быть указано." unless purpose
    raise "Общий объём вагона должен быть указан." unless capacity
    true
  end
end
