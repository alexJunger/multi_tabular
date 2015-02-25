module MultiTabular
  # For subclasses of an MTI construct.
  # These classes inherit logic from a superclass and are persisted in their own table.
  module Sub
    extend ActiveSupport::Concern

    # Set the table name to be the class name, including namespaces.
    # If a different table should be used, override this variable in your class.
    included do
      self.table_name = name.underscore.sub('/', '_').pluralize
    end
  end
end