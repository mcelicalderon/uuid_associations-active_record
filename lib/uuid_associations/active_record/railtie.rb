require 'uuid_associations/active_record/association_method_definitions'

module UuidAssociations
  module ActiveRecord
    class Railtie < Rails::Railtie
      initializer 'uuid_associations.apply_extension' do |app|
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::Associations.eager_load!

          extend UuidAssociations::ActiveRecord::AssociationMethodDefinitions
        end
      end
    end
  end
end
