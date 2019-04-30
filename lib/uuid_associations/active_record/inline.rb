require 'active_record'
require 'active_record/associations'
require 'uuid_associations/active_record/association_method_definitions'
require 'uuid_associations/active_record/nested_attributes_method_definitions'

::ActiveRecord::Base.extend(UuidAssociations::ActiveRecord::AssociationMethodDefinitions)
::ActiveRecord::Base.prepend(UuidAssociations::ActiveRecord::NestedAttributesMethodDefinitions)
::ActiveRecord::Base.extend(UuidAssociations::ActiveRecord::NestedAttributesMethodDefinitions::ClassMethods)
