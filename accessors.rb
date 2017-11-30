
module Accessors
  def attr_accessor_with_history(*names)
    names.each do |attr_name|
      var_name = "@#{attr_name}".to_sym
      define_method(attr_name.to_sym) { instance_variable_get(var_name) }
      define_method("#{attr_name}=".to_sym) do |value|
        instance_eval("@#{attr_name}_history ||= []")
        instance_variable_set(var_name, value)
        instance_eval("@#{attr_name}_history << #{value.inspect}")
      end
      history_var_name = "@#{attr_name}_history".to_sym
      define_method("#{attr_name}_history".to_sym) { instance_variable_get(history_var_name) }
    end
  end

  def strong_attr_accessor(attr_name, attr_class)
    var_name = "@#{attr_name}".to_sym
    define_method(attr_name.to_sym) { instance_variable_get(var_name) }
    define_method("#{attr_name}=".to_sym) do |value|
      instruction = "#{value.inspect} is not a #{attr_class}"
      instance_eval(
        "raise TypeError, '#{instruction}' unless #{value.inspect}.is_a?(#{attr_class})"
      )
      instance_variable_set(var_name, value)
    end
  end
end
