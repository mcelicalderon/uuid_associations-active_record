require 'active_record'
require 'active_record/associations'
require 'uuid_associations/active_record/association_method_definitions'

::ActiveRecord::Base.extend(UuidAssociations::ActiveRecord::AssociationMethodDefinitions)
