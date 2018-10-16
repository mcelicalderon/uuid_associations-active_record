require 'active_record'
require 'active_record/associations'
require 'uuid_associations/active_record/method_definitions'

::ActiveRecord::Associations::ClassMethods.prepend UuidAssociations::ActiveRecord::MethodDefinitions
