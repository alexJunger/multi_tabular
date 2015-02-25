module MultiTabular
  # For superclasses of an MTI construct.
  # These classes can provide shared logic, but are not an activerecord-model on their own,
  # meaning they have no corresponding table in the database.
  module Super
    extend ActiveSupport::Concern

    included do
      self.abstract_class = true

      # Allow converting the class name to an assumed foreign key in an associated model's database.
      # If a different foreign should be used, you can override this method or simply declare the foreign key manually.
      def self.to_foreign_key
        name.underscore.sub('/', '_').singularize << '_id'
      end
    end
  end
end