require 'active_support/concern'

module MultiTabular
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