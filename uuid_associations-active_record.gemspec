lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uuid_associations/active_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'uuid_associations-active_record'
  spec.version       = UuidAssociations::ActiveRecord::VERSION
  spec.authors       = ['Mario Celi']
  spec.email         = ['mcelicalderon@gmail.com']

  spec.summary       = 'Helper methods for UUID associations in Active Record'
  spec.description   = 'Adds association_uuids= method on has_many and has_and_belongs_to_many associations'
  spec.homepage      = 'https://github.com/mcelicalderon/uuid_associations-active_record'
  spec.license       = 'MIT'
  spec.metadata      = {
    'source_code_uri' => 'https://github.com/mcelicalderon/uuid_associations-active_record'
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|gemfiles)/}) }
  end
  spec.test_files    = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select { |f| f.match(%r{^spec/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'activerecord', '>= 4.2', '< 8.0'

  spec.add_development_dependency 'appraisal', '~> 2.0'
  spec.add_development_dependency 'github_changelog_generator'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
