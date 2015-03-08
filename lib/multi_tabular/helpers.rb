module MultiTabular
  module Helpers
    # Allow converting the class name to an assumed foreign key in an associated model's database.
    # If a different foreign should be used, you can override this method or simply declare the foreign key manually.
    def self.to_foreign_key(klass)
      klass.name.underscore.sub('/', '_').singularize << '_id'
    end

    def self.define_associations(klass, assoc_list)
      return if assoc_list.nil?

      assoc_list.each do |assoc|
        options = assoc[:opts].deep_dup
        options[:foreign_key] ||= to_foreign_key(klass) unless options[:through]
        options[:inverse_of] = reflection_symbol(klass) if options[:define_inverse]
        options.delete(:define_inverse)

        if assoc[:multiple]
          klass.has_many assoc[:name], options
        else
          klass.has_one assoc[:name], options
        end
      end
    end

    # for a given class, returns the appropriate symbol
    # to pass to the ActiveRecord method reflect_on_association
    def self.reflection_symbol(klass)
      klass.to_s.gsub(/::/, '_').underscore.to_sym
    end

    # Check if guessed or passed in constant is a class and is a descendant of ActiveRecord::Base
    def self.validate_base_class(bc)
      bc.is_a?(Class) && bc < ActiveRecord::Base
    end
  end
end