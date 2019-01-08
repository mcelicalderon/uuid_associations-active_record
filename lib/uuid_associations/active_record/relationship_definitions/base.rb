module UuidAssociations
  module ActiveRecord
    module RelationshipDefinitions
      class Base
        def self.define_accesors_for(klass, payload, name)
          new(klass, payload, name).call
        end

        def initialize(klass, payload, name)
          @klass   = klass
          @payload = payload
          @name    = name.to_s
        end

        def call
          reflection = find_reflection(payload)
          association_class_name = reflection.class_name

          define_accesors(klass, association_class_name) if uuid_column?(association_class_name)

          payload
        end

        private

        attr_reader :payload, :klass, :name

        def find_reflection(payload)
          payload[name]
        end

        def table_name_from_class_name(class_name)
          class_name.underscore.pluralize
        end

        def uuid_column?(association_class_name)
          ::ActiveRecord::Base.connection

          table_name = table_name_from_class_name(association_class_name)
          return false unless ::ActiveRecord::Base.connection.tables.include?(table_name)

          ::ActiveRecord::Base.connection.columns(table_name).any? do |column|
            column.name == 'uuid'
          end
        rescue ::ActiveRecord::NoDatabaseError
          false
        end
      end
    end
  end
end
