module UuidAssociations
  module ActiveRecord
    module NestedAttributes
      class UuidFinder
        def self.replaced_uuids_with_ids(association_klass, attribute_collection)
          new(association_klass, attribute_collection).call
        end

        def initialize(association_klass, attribute_collection)
          @association_klass    = association_klass
          @attribute_collection = attribute_collection
        end

        def call
          to_replace, to_keep = attribute_collection.partition do |attributes|
            symbol_keys = attributes.keys.map(&:to_sym)

            (symbol_keys & [:uuid, :id]) == [:uuid]
          end

          uuids_to_find = to_replace.map { |element| element[:uuid] }
          found_records = association_klass.where(uuid: uuids_to_find)

          replaced = to_replace.each_with_object([]) do |attributes, collection|
            uuid = attributes.delete(:uuid)

            record = found_records.find { |found_record| found_record.uuid == uuid }

            if record.blank?
              raise_not_found_error(uuid)
            end

            collection << attributes.merge(id: record.id)
          end

          to_keep + replaced
        end

        private

        def attribute_collection
          @attribute_collection.instance_of?(Hash) ? @attribute_collection.values : @attribute_collection
        end

        def raise_not_found_error(uuid)
          if ::ActiveRecord.version < Gem::Version.new('5.0')
            raise ::ActiveRecord::RecordNotFound, "Couldn't find #{association_klass.name} with UUID=#{uuid}"
          else
            raise ::ActiveRecord::RecordNotFound.new(
              "Couldn't find #{association_klass.name} with UUID=#{uuid}", association_klass, :id, uuid
            )
          end
        end

        attr_reader :association_klass
      end
    end
  end
end
