# frozen_string_literal: true

require 'uuid_associations/active_record/relationship_definitions/belongs_to'
require 'uuid_associations/active_record/relationship_definitions/has_many'

module UuidAssociations
  module ActiveRecord
    module AssociationMethodDefinitions
      def has_many(name, scope = nil, **options, &extension)
        original_payload = super(name, scope, **options, &extension)
        RelationshipDefinitions::HasMany.define_accesors_for(self, original_payload, name)

        original_payload
      end

      def belongs_to(name, scope = nil, **options)
        original_payload = super(name, scope, **options)
        return original_payload if original_payload.key?('left_side')

        RelationshipDefinitions::BelongsTo.define_accesors_for(self, original_payload, name)

        original_payload
      end
    end
  end
end
