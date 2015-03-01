require 'active_support/concern'

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
  end

  # For superclasses of an MTI construct.
  # These classes can provide shared logic, but are not an activerecord-model on their own,
  # meaning they have no corresponding table in the database.
  module Super
    extend ActiveSupport::Concern

    module ClassMethods
      def child_has_one(assoc_name, opts = {})
        @child_assocs_list ||= []
        @child_assocs_list << {
            multiple: false,
            name: assoc_name,
            opts: opts
        }
      end

      def child_has_many(assoc_name, opts = {})
        @child_assocs_list ||= []
        @child_assocs_list << {
            multiple: true,
            name: assoc_name,
            opts: opts
        }
      end
    end

    def self.included(base)
      base.abstract_class = true

      def base.inherited(child)
        return if self.eql?(child)

        MultiTabular::Helpers.define_associations(child, @child_assocs_list)

        super

        child.table_name = child.name.underscore.sub('/', '_').pluralize
      end
    end
  end
end