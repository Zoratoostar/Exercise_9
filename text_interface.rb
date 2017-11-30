
class TextInterface
  attr_reader :stations, :cargo_trains, :passenger_trains, :routes

  def initialize
    @stations = []
    @cargo_trains = []
    @passenger_trains = []
    @routes = []
  end

  def start_menu
    loop do
      puts " Выберите вариант путём ввода номера пункта меню:"
      puts " 0 Выход."
      puts " 1 Создать станцию."
      puts " 2 Создать поезд."
      puts " 3 Прицепить или отцепить вагоны от поезда."
      puts " 4 Занять места или заполнить объём в вагоне."
      puts " 5 Создать маршрут."
      puts " 6 Добавить или удалить станции из маршрута."
      puts " 7 Назначить маршрут поезду."
      puts " 8 Переместить поезд по маршруту."
      puts " 9 Получить список станций и поездов."
      print " "
      begin
        case gets.strip
        when '0' then puts; break
        when '1' then create_station
        when '2'
          puts "  Выберите вариант:"
          puts "  1 Создать грузовой поезд."
          puts "  2 Создать пассажирский поезд."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1' then create_cargo_train
          when '2' then create_passenger_train
          end
        when '3'
          puts "  Выберите вариант:"
          puts "  1 Прицепить вагоны к поезду."
          puts "  2 Отцепить вагоны от поезда."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1'
            puts "   Выберите вариант:"
            puts "   1 Добавить вагоны к грузовому поезду."
            puts "   2 Добавить вагоны к пассажирскому поезду."
            print "   "
            case gets.strip
            when '1' then add_freight_wagons
            when '2' then add_passanger_carriages
            end
          when '2'
            puts "   Выберите вариант:"
            puts "   1 Отцепить вагоны от грузового поезда."
            puts "   2 Отцепить вагоны от пассажирского поезда."
            print "   "
            case gets.strip
            when '1' then unhook_freight_wagons
            when '2' then unhook_passanger_carriages
            end
          end
        when '4'
          fill_or_occupy
        when '5' then create_route
        when '6'
          puts "  Выберите вариант:"
          puts "  1 Добавить станции к маршруту."
          puts "  2 Удалить станции из маршрута."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1' then add_stations_to_route
          when '2' then delete_stations_from_route
          end
        when '7'
          puts "  Выберите вариант:"
          puts "  1 Назначить маршрут грузовому поезду."
          puts "  2 Назначить маршрут пассажирскому поезду."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1' then assign_route_to_cargo_train
          when '2' then assign_route_to_passanger_train
          end
        when '8'
          puts "  Выберите вариант:"
          puts "  1 Переместить грузовой поезд по назначенному маршруту."
          puts "  2 Переместить пассажирский поезд по назначенному маршруту."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1' then shift_cargo_train
          when '2' then shift_passanger_train
          end
        when '9' then lists
        end
      rescue StandardError => error
        puts "Произошла ошибка:"
        puts error.message
        puts error.backtrace
      end
    end
  end

  private

  def print_error(exception, indent = 4)
    puts
    puts "#{' ' * indent}#{exception.message}"
    puts
  end

  def create_station
    print "  Введите название станции: "
    name = gets.strip
    stations << Station.new(name)
    puts
  rescue StandardError => e
    print_error(e)
    retry
  end

  def create_cargo_train
    print "   Введите идентификатор грузового поезда: "
    name = gets.strip
    cargo_trains << CargoTrain.new(name)
    puts
  rescue StandardError => e
    print_error(e)
    retry
  end

  def create_passenger_train
    print "   Введите идентификатор пассажирского поезда: "
    name = gets.strip
    passenger_trains << PassengerTrain.new(name)
    puts
  rescue StandardError => e
    print_error(e)
    retry
  end

  def print_list(array, indent = 3)
    array.each_with_index do |name, index|
      puts "#{' ' * indent}#{index + 1}. #{name}"
    end
  end

  def add_freight_wagons
    puts "    Выберите грузовой поезд, которому необходимо добавить вагоны:"
    print_list(cargo_trains, 4)
    puts "    Для перехода к предыдущему меню введите любое другое значение."
    print "    "
    index = gets.to_i - 1
    train = cargo_trains[index] if index >= 0
    if train
      loop do
        puts "     Список вагонов поезда \"#{train}\" следующий:"
        puts "     #{train.list_carriages}"
        puts "     Добавить новый вагон ?"
        puts "     Введите 1 или 2 для подтверждения данного действия."
        print "     "
        response = gets.to_i
        if (1..2).cover?(response)
          begin
            puts "      Введите номер вагона:"
            print "      "
            number = gets.strip
            puts "      Укажите предназначение или тип вагона:"
            print "      "
            purpose = gets.strip
            puts "      Укажите грузоподъёмность вагона:"
            print "      "
            capacity = gets.strip
            wagon = FreightWagon.new(number, purpose, capacity)
          rescue StandardError => e
            print_error(e, 8)
            retry
          end
          train.hitch_carriage(wagon)
        else
          break
        end
      end
    end
    puts
  end

  def add_passanger_carriages
    puts "    Выберите пассажирский поезд, которому необходимо добавить вагоны:"
    print_list(passenger_trains, 4)
    puts "    Для перехода к предыдущему меню введите любое другое значение."
    print "    "
    index = gets.to_i - 1
    train = passenger_trains[index] if index >= 0
    if train
      loop do
        puts "     Список вагонов поезда \"#{train}\" следующий:"
        puts "     #{train.list_carriages}"
        puts "     Добавить новый вагон ?"
        puts "     Введите 1 или 2 для подтверждения данного действия."
        print "     "
        response = gets.to_i
        if (1..2).cover?(response)
          begin
            puts "      Введите номер вагона:"
            print "      "
            number = gets.strip
            puts "      Укажите число посадочных мест:"
            print "      "
            seats = gets.to_i
            wagon = PassengerCarriage.new(number, seats)
          rescue StandardError => e
            print_error(e, 8)
            retry
          end
          train.hitch_carriage(wagon)
        else
          break
        end
      end
    end
    puts
  end

  def unhook_freight_wagons
    puts "    Выберите грузовой поезд, от которого следует отцепить вагоны:"
    print_list(cargo_trains, 4)
    puts "    Для перехода к предыдущему меню введите любое другое значение."
    print "    "
    index = gets.to_i - 1
    train = cargo_trains[index] if index >= 0
    if train
      puts "     Список вагонов грузового поезда \"#{train}\" следующий:"
      puts "     #{train.list_carriages}"
      puts "     Сколько вагонов следует отцепить ?"
      print "     "
      count = gets.to_i
      count.times { train.unhook_carriage }
      puts "     Список оставшихся вагонов поезда \"#{train}\":"
      puts "     #{train.list_carriages}"
      print "     "
      gets
    end
    puts
  end

  def unhook_passanger_carriages
    puts "    Выберите пассажирский поезд, от которого следует отцепить вагоны:"
    print_list(passenger_trains, 4)
    puts "    Для перехода к предыдущему меню введите любое другое значение."
    print "    "
    index = gets.to_i - 1
    train = passenger_trains[index] if index >= 0
    if train
      puts "     Список вагонов пассажирского поезда \"#{train}\" следующий:"
      puts "     #{train.list_carriages}"
      puts "     Сколько вагонов следует отцепить ?"
      print "     "
      count = gets.to_i
      count.times { train.unhook_carriage }
      puts "     Список оставшихся вагонов поезда \"#{train}\":"
      puts "     #{train.list_carriages}"
      print "     "
      gets
    end
    puts
  end

  def fill_or_occupy
    puts "  Выберите станцию, принявшую нужный поезд:"
    print_list(stations, 2)
    print "  "
    index = gets.to_i - 1
    accepting_station = stations[index] if index >= 0
    if accepting_station
      puts "   Выберите поезд:"
      accepting_station.each_train do |trn, ind|
        puts "   #{ind + 1}. #{trn}"
      end
      print "   "
      index = gets.to_i - 1
      train = accepting_station.trains[index] if index >= 0
      if train.is_a?(CargoTrain)
        puts "    Выберите товарный вагон:"
        puts "    номер = предназначение = грузоподъёмность => доступный_объём"
        train.each_carriage do |wagon, ind|
          puts "    #{ind + 1}. #{wagon}"
        end
        print "    "
        index = gets.to_i - 1
        wagon = train.carriages[index] if index >= 0
        if wagon.is_a?(FreightWagon)
          puts "     Вагон номер #{wagon.number}"
          puts "     предназанчение: #{wagon.purpose}"
          puts "     грузоподъёмность: #{wagon.capacity}"
          puts "     занятый объём:    #{wagon.filled_capacity}"
          puts "     доступный объём:  #{wagon.available_capacity}"
          puts
          print "     Введите занимаемый грузом объём: "
          value = gets.to_i
          puts
          return if value.zero?
          if value > wagon.available_capacity
            puts "     Слишком объёмный груз. Погрузка не может быть произведена."
          else
            wagon.fill_in_capacity(value)
            puts "     Погрузка произведена."
          end
        end
      elsif train.is_a?(PassengerTrain)
        puts "    Выберите пассажирский вагон:"
        puts "    номер :: посадочных_мест_всего => доступно_мест"
        train.each_carriage do |car, ind|
          puts "    #{ind + 1}. #{car}"
        end
        print "    "
        index = gets.to_i - 1
        car = train.carriages[index] if index >= 0
        if car.is_a?(PassengerCarriage)
          puts "     Вагон номер #{car.number}"
          puts "     посадочных мест: #{car.seats}"
          puts "     из них занято:   #{car.occupied_seats}"
          puts "     доступно мест:   #{car.vacant_seats}"
          puts
          print "     Введите количество занимаемых мест: "
          number = gets.to_i
          puts
          return if number.zero?
          if number > car.vacant_seats
            puts "     Отсутствует заданное число мест. Посадка не удалась."
          else
            number.times { car.occupy_seat }
            puts "     Посадка пассажиров произведена."
          end
        end
      end
    end
    puts
  end

  def create_route
    puts "  Выберите начальную станцию маршрута из следующего списка:"
    print_list(stations, 2)
    print "  "
    index = gets.to_i - 1
    initial_station = stations[index] if index >= 0
    if initial_station
      puts "  Выберите конечную станцию маршрута из приведённого выше списка:"
      print "  "
      index = gets.to_i - 1
      final_station = stations[index] if index >= 0
      if final_station && initial_station != final_station
        routes << Route.new(initial_station, final_station)
      end
    end
    puts
  end

  def add_stations_to_route
    puts "  Выберите маршрут для добавления к нему станций:"
    print_list(routes, 2)
    print "  "
    index = gets.to_i - 1
    route = routes[index] if index >= 0
    if route
      available_stations = []
      stations.each do |stn|
        available_stations << stn unless route.stations.include?(stn)
      end
      loop do
        puts "   Выберите станцию для добавления из доступных:"
        print_list(available_stations)
        puts "   Введите номер, любое отличное значение отменит действие."
        print "   "
        index = gets.to_i - 1
        avl_stn = available_stations[index] if index >= 0
        if avl_stn
          route.add_station(avl_stn)
          available_stations.delete(avl_stn)
          puts "    Маршрут изменён:"
          puts "    #{route}"
          print "    "
          gets
        else
          break
        end
      end
    end
    puts
  end

  def delete_stations_from_route
    puts "  Выберите маршрут для удаления из него станций:"
    print_list(routes, 2)
    print "  "
    index = gets.to_i - 1
    route = routes[index] if index >= 0
    if route
      loop do
        break if route.stations.length == 2
        puts "   Выберите станцию для удаления:"
        print_list(route.stations)
        puts "   Введите номер, любое отличное значение отменит действие."
        print "   "
        index = gets.to_i - 1
        stn = route.stations[index] if index >= 0
        if stn
          route.delete_station(stn)
          puts "    Маршрут изменён:"
          puts "    #{route}"
          print "    "
          gets
        else
          break
        end
      end
    end
    puts
  end

  def assign_route_to_cargo_train
    puts "   Выберите грузовой поезд, которому нужно назначить маршрут:"
    print_list(cargo_trains)
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = cargo_trains[index] if index >= 0
    if train
      puts "    Выберите маршрут для назначения грузовому поезду \"#{train}\":"
      print_list(routes, 4)
      print "    "
      index = gets.to_i - 1
      route = routes[index] if index >= 0
      train.assign_route(route) if route
    end
    puts
  end

  def assign_route_to_passanger_train
    puts "   Выберите пассажирский поезд, которому нужно назначить маршрут:"
    print_list(passenger_trains)
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = passenger_trains[index] if index >= 0
    if train
      puts "    Выберите маршрут для назначения пассажирскому поезду \"#{train}\":"
      print_list(routes, 4)
      print "    "
      index = gets.to_i - 1
      route = routes[index] if index >= 0
      train.assign_route(route) if route
    end
    puts
  end

  def shift_cargo_train
    puts "   Выберите грузовой поезд для перемещения по маршруту:"
    print_list(cargo_trains)
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = cargo_trains[index] if index >= 0
    if train && train.route
      loop do
        puts "    Маршрут грузового поезда следующий:"
        puts "    #{train.route}"
        puts
        puts "    Текущая станция: \"#{train.current_station}\""
        puts
        puts "    1 Вперёд к следующей станции."
        puts "    6 Назад к предыдущей станции."
        puts "    0 Выход в главное меню."
        print "    "
        case gets.strip
        when '1' then train.shift_forward
        when '6' then train.shift_backward
        when '0' then break
        end
      end
    end
    puts
  end

  def shift_passanger_train
    puts "   Выберите пассажирский поезд для перемещения по маршруту:"
    print_list(passenger_trains)
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = passenger_trains[index] if index >= 0
    if train && train.route
      loop do
        puts "    Маршрут пассажирского поезда следующий:"
        puts "    #{train.route}"
        puts
        puts "    Текущая станция: \"#{train.current_station}\""
        puts
        puts "    1 Вперёд к следующей станции."
        puts "    6 Назад к предыдущей станции."
        puts "    0 Выход в главное меню."
        print "    "
        case gets.strip
        when '1' then train.shift_forward
        when '6' then train.shift_backward
        when '0' then break
        end
      end
    end
    puts
  end

  def lists
    puts "  Доступен следующий список станций:"
    print_list(stations, 2)
    puts "  Выберите нужную станцию для просмотра списка прибывших поездов."
    puts "  Для перехода к предыдущему меню введите любое другое значение."
    print "  "
    index = gets.to_i - 1
    station = stations[index] if index >= 0
    if station
      puts "   Выберите вариант получения списка:"
      puts "   1 Грузовые поезда."
      puts "   2 Пассажирские поезда."
      puts "   3 Общий список всех поездов."
      print "   "
      case gets.strip
      when '1'
        puts "    Список грузовых поездов на станции \"#{station}\":"
        print_list(station.list_freight_trains, 4)
        print "    "
        gets
      when '2'
        puts "    Список пассажирских поездов на станции \"#{station}\":"
        print_list(station.list_passenger_trains, 4)
        print "    "
        gets
      when '3'
        puts "    Общий список поездов на станции \"#{station}\":"
        print_list(station.list_all_trains, 4)
        print "    "
        gets
      end
    end
    puts
  end
end
