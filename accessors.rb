
module Accessors
  def attr_accessor_with_history(*names)
    names.each do |attr_name|
      var_name = "@#{attr_name}"
      define_method(attr_name.to_sym) { instance_variable_get(var_name) }
      history_var_name = "@#{attr_name}_history"
      define_method("#{attr_name}=".to_sym) do |value|
        instance_variable_set(history_var_name, []) unless instance_variable_get(history_var_name)
        instance_variable_set(var_name, value)
        instance_variable_get(history_var_name) << value
      end
      define_method("#{attr_name}_history".to_sym) { instance_variable_get(history_var_name) }
    end
  end

  def strong_attr_accessor(attr_name, attr_class)
    var_name = "@#{attr_name}".to_sym
    define_method(attr_name.to_sym) { instance_variable_get(var_name) }
    define_method("#{attr_name}=".to_sym) do |value|
      instruction = "#{value.inspect} is not a #{attr_class}"
      raise TypeError, instruction unless value.is_a?(attr_class)
      instance_variable_set(var_name, value)
    end
  end
end
