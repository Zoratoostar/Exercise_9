
class CargoTrain < Train
  def hitch_carriage(car)
    super(car) if car.is_a?(FreightWagon)
  end

  def to_s
    "#{unique_number}_cargo_#{carriages.count}"
  end
end
