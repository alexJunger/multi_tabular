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

        assoc[:opts][:foreign_key] ||= to_foreign_key(klass) unless assoc[:opts][:through]

        if assoc[:multiple]
          klass.has_many assoc[:name], assoc[:opts]
        else
          klass.has_one assoc[:name], assoc[:opts]
        end
      end
    end

    # for a given class, returns the appropriate symbol
    # to pass to the ActiveRecord method reflect_on_association
    def self.reflection_symbol(klass)
      klass.to_s.gsub(/::/, '_').underscore.to_sym
    end
  end
end