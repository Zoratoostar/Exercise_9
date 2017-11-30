
module Validation
  def self.included(recipient)
    recipient.extend ClassMethods
    recipient.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, mode, option = nil)
      class_eval("@@_validations ||= {}")
      case mode.to_sym
      when :presence
        mtd_symb = define_method("_valid_#{name}_presence".to_sym) do
          instruction = "@#{name} must be present"
          instance_eval("raise ArgumentError, '#{instruction}' if @#{name}.nil?")
        end
      when :format
        exit unless option.is_a?(Regexp)
        mtd_symb = define_method("_valid_#{name}_format".to_sym) do
          instruction = "@#{name} is not satisfy #{option.inspect}"
          instance_eval(
            "raise RegexpError, '#{instruction}' if @#{name} !~ #{option.inspect}"
          )
        end
      when :type
        exit unless option.is_a?(Class)
        mtd_symb = define_method("_valid_#{name}_type") do
          instruction = "@#{name} is not a #{option}"
          instance_eval(
            "raise TypeError, '#{instruction}' unless @#{name}.is_a?(#{option})"
          )
        end
      else exit
      end
      class_eval("@@_validations[#{mtd_symb.inspect}] = true")
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue StandardError
      false
    end

    private

    def validate!
      mtds = self.class.class_variable_get(:@@_validations)
      mtds && mtds.each_key { |mtd_symb| send(mtd_symb) }
      true
    end
  end
end
