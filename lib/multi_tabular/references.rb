require 'pry'

module MultiTabular
  # For classes that reference an MTI class
  module References
    extend ActiveSupport::Concern

    included do
      def reflection_assignment_method(klass)
        self.class.reflect_on_association(Helpers.reflection_symbol(klass)).name.to_s + '='
      end

      def reflection_assignment_symbol(sym)
        self.class.reflect_on_association(sym).name.to_s + '='
      end

      # for all subclasses of the given base class, returns a
      # list of defined associations within the current class
      def association_methods(mti_base_class)
        (mti_base_class.descendants << mti_base_class).map{|s|
          assoc = self.class.reflect_on_association(Helpers.reflection_symbol s)
          assoc ? assoc.name : nil
        }.compact
      end
    end

    module ClassMethods
      # create a polymorphic association to an MTI construct in a belongs_to fashion,
      # meaning that the table of the class including this mixin has a foreign key to each of the MTI construct's
      # concrete models. It defines a getter and setter method named like the assoc_sym argument.
      # The method tries to guess the base class itself based on the association name, but if namespaces or an arbitrary
      # association name is used, the name of the base class should be passed as string with base_class: 'BaseClassName"
      def belongs_to_mti(assoc_sym, params = {})
        # Check if guessed or passed in constant is a class and is a descendant of ActiveRecord::Base
        def validate_base_class(bc)
          bc.is_a?(Class) && bc < ActiveRecord::Base
        end

        if params.key? :base_class
          base_class = Module.const_get params[:base_class]
        else
          base_class = Module.const_get assoc_sym.capitalize
        end

        # Raise an error if the base class doesn't saturate the conditions.
        unless validate_base_class base_class
          fail InvalidBaseClassError.new "#{base_class} is not a valid base class."
        end

        base_class.descendants.each do |descendant|
          self.belongs_to Helpers.reflection_symbol(descendant),
                          class_name: descendant.to_s,
                          foreign_key: "#{Helpers.reflection_symbol(descendant)}_id"
        end

        # Define the getter method for retrieving a referenced MTI record.
        # Each association method for the base class is invoked and first that returns a result will be used.
        define_method(assoc_sym.to_s) do
          association_methods(base_class).map do|a|
            send a
          end.reduce do |a, b|
            a || b
          end
        end

        define_method("count_#{assoc_sym.to_s.pluralize}") do
          association_methods(base_class).reduce(0) do |sum, method|
            send(method) ? sum + 1 : sum
          end
        end

        # Define the setter method that dynamically accesses the concrete setter for the type of the assignee.
        define_method("#{assoc_sym}=") do |assignee|
          association_methods(base_class).each do |association|
            send reflection_assignment_symbol(association), nil
          end

          send reflection_assignment_method(assignee.class), assignee
        end
      end
    end
  end
end

class ActiveRecord::Base
  include MultiTabular::References
end
