if defined?(Rails::Railtie)
  require 'uuid_associations/active_record/railtie'
else
  require 'uuid_associations/active_record/inline'
end
