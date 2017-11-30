
module InstanceCounter
  def self.included(recipient)
    recipient.extend ClassMethods
    recipient.send :include, InstanceMethods
    recipient.instances = 0
  end

  module ClassMethods
    attr_accessor :instances
  end

  module InstanceMethods
    private

    def register_instance
      self.class.instances += 1
    end
  end
end
