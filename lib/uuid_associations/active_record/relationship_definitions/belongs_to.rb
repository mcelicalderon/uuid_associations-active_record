# frozen_string_literal: true

require 'uuid_associations/active_record/relationship_definitions/base'

module UuidAssociations
  module ActiveRecord
    module RelationshipDefinitions
      class BelongsTo < Base
        private

        def define_accesors(klass, association_class_name)
          klass.class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{name}_uuid=(uuid)
              if uuid.nil?
                self.#{name}_id = nil
              else
                self.#{name}_id = #{association_class_name}.find_by!(uuid: uuid).id
              end
            end
          CODE

          klass.class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{name}_uuid
              #{name}.uuid
            end
          CODE
        end
      end
    end
  end
end
