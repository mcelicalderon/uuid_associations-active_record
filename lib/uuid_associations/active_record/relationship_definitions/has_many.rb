require 'uuid_associations/active_record/relationship_definitions/base'

module UuidAssociations
  module ActiveRecord
    module RelationshipDefinitions
      class HasMany < Base
        private

        def define_accesors(klass, association_class_name)
          klass.class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{name.singularize}_uuids=(uuids)
              self.#{name.singularize}_ids = #{association_class_name}.where(uuid: uuids).pluck(:id)
            end
          CODE

          klass.class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{name.singularize}_uuids
              #{name}.pluck(:uuid)
            end
          CODE
        end
      end
    end
  end
end
