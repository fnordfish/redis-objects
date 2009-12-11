# This is the class loader, for use as "include Redis::Objects::Values"
# For the object itself, see "Redis::Value"
require 'redis/value'
class Redis
  module Objects
    module Values
      def self.included(klass)
        klass.send :include, InstanceMethods
        klass.extend ClassMethods
      end

      # Class methods that appear in your class when you include Redis::Objects.
      module ClassMethods
        # Define a new simple value.  It will function like a regular instance
        # method, so it can be used alongside ActiveRecord, DataMapper, etc.
        def value(name, options={})
          @redis_objects[name] = options.merge(:type => :value)
          class_eval <<-EndMethods
            def #{name}
              @#{name} ||= Redis::Value.new(field_key(:#{name}), redis, self.class.redis_objects[:#{name}])
            end
            def #{name}=(value)
              #{name}.value = value
            end
          EndMethods
        end
      end
      
      # Instance methods that appear in your class when you include Redis::Objects.
      module InstanceMethods
      end
    end
  end
end