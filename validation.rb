
module Validation
  def self.included(recipient)
    recipient.extend ClassMethods
    recipient.send :include, InstanceMethods
    recipient.instance_variable_set(:@validations, {})
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, mode, option = nil)
      validations["validate_#{mode}!".to_sym] = {name: name, opt: option}
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue StandardError
      false
    end

    private

    def validate_presence!(name, _option)
      instruction = "@#{name} must be present"
      raise ArgumentError, instruction if instance_variable_get("@#{name}").nil?
    end

    def validate_format!(name, option)
      exit unless option.is_a?(Regexp)
      instruction = "@#{name} is not satisfy #{option.inspect}"
      raise RegexpError, instruction if instance_variable_get("@#{name}") !~ option
    end

    def validate_type!(name, option)
      exit unless option.is_a?(Class)
      instruction = "@#{name} is not a #{option}"
      raise TypeError, instruction unless instance_variable_get("@#{name}").is_a?(option)
    end

    def validate!
      mtds = self.class.validations
      mtds && mtds.each { |mtd, val| send(mtd, val.fetch(:name), val.fetch(:opt)) }
      true
    end
  end
end
