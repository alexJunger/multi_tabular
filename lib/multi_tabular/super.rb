module MultiTabular
  # For superclasses of an MTI construct.
  # These classes can provide shared logic, but are not an activerecord-model on their own,
  # meaning they have no corresponding table in the database.
  module Super
    def self.included(base)
      base.abstract_class = true

      def base.inherited(child)
        # Allow converting the class name to an assumed foreign key in an associated model's database.
        # If a different foreign should be used, you can override this method or simply declare the foreign key manually.
        def child.to_foreign_key
          name.underscore.sub('/', '_').singularize << '_id'
        end

        return if self.eql?(child)
        if self.respond_to?(:inherited_associations)
          self.inherited_associations(child)
        end

        # TODO make this work
        # child.table_name = child.name.underscore.sub('/', '_').pluralize
      end
    end
  end
end