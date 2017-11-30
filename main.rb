
require_relative 'accessors.rb'
require_relative 'validation.rb'
require_relative 'company'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'carriage'
require_relative 'passenger_carriage'
require_relative 'freight_wagon'
require_relative 'station'
require_relative 'route'
require_relative 'text_interface'

interface = TextInterface.new
interface.start_menu
