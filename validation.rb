
module Validation
  def self.included(recipient)
    recipient.extend ClassMethods
    recipient.send :include, InstanceMethods
    recipient.instance_variable_set(:@validations, {})
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, mode, option = nil)
      name = name.to_sym
      validations[name] ||= []
      validations[name] << {method: "validate_#{mode}!".to_sym, opt: option}
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue StandardError
      false
    end

    private

    def validate_presence!(name, var_value, _option)
      instruction = "@#{name} must be present"
      raise ArgumentError, instruction if var_value.nil?
    end

    def validate_format!(name, var_value, option)
      exit unless option.is_a?(Regexp)
      instruction = "@#{name} is not satisfy #{option.inspect}"
      raise RegexpError, instruction if var_value !~ option
    end

    def validate_type!(name, var_value, option)
      exit unless option.is_a?(Class)
      instruction = "@#{name} is not a #{option}"
      raise TypeError, instruction unless var_value.is_a?(option)
    end

    def validate!
      self.class.validations.each do |name, vals|
        var_value = instance_variable_get("@#{name}")
        vals.each do |val|
          next unless self.class.private_method_defined?(val.fetch(:method))
          send(val.fetch(:method), name, var_value, val.fetch(:opt))
        end
      end
      true
    end
  end
end
