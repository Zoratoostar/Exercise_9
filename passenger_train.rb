
class PassengerTrain < Train
  def hitch_carriage(car)
    super(car) if car.is_a?(PassengerCarriage)
  end

  def to_s
    "#{unique_number}_pssngr_#{carriages.count}"
  end
end
