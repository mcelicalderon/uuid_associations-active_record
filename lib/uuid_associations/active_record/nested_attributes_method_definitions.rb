require 'uuid_associations/active_record/nested_attributes/uuid_finder'

module UuidAssociations
  module ActiveRecord
    module NestedAttributesMethodDefinitions
      private

      def assign_nested_attributes_for_collection_association(association_name, attributes_collection)
        association_klass = association(association_name).reflection.klass
        unless nested_association_uuid_searchable?(association_klass, attributes_collection)
          return super(association_name, attributes_collection)
        end

        replaced_attributes = ActiveRecord::NestedAttributes::UuidFinder.replaced_uuids_with_ids(
          association_klass,
          attributes_collection
        )
        super(association_name, replaced_attributes)
      end

      def nested_association_uuid_searchable?(association_klass, attributes_collection)
        association_klass.column_names.include?('uuid') &&
          (attributes_collection.instance_of?(Hash) || attributes_collection.instance_of?(Array))
      end
    end
  end
end
