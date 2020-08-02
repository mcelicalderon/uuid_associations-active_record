# frozen_string_literal: true

require 'uuid_associations/active_record/nested_attributes/uuid_finder'

module UuidAssociations
  module ActiveRecord
    module NestedAttributesMethodDefinitions
      module ClassMethods
        def accepts_nested_attributes_for(*attr_names)
          options = attr_names.extract_options!
          create_missing_uuids = { create_missing_uuids: options.delete(:create_missing_uuids) { false } }

          original_payload = super(
            *(attr_names + [options])
          )

          attr_names.each do |association_name|
            nested_attributes_options = self.nested_attributes_options.dup
            nested_attributes_options[association_name.to_sym] = nested_attributes_options[association_name.to_sym].merge(create_missing_uuids)
            self.nested_attributes_options = nested_attributes_options
          end

          original_payload
        end
      end

      private

      def assign_nested_attributes_for_collection_association(association_name, attributes_collection)
        association_klass = association(association_name).reflection.klass
        unless nested_association_uuid_searchable?(association_klass, attributes_collection)
          return super(association_name, attributes_collection)
        end

        replaced_attributes = ActiveRecord::NestedAttributes::UuidFinder.replaced_uuids_with_ids(
          association_klass,
          attributes_collection,
          nested_attributes_options[association_name]
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
