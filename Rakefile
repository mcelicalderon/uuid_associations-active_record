# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'mcelicalderon'
  config.project = 'uuid_associations-active_record'
  config.future_release = ENV['FUTURE_RELEASE']
  config.add_issues_wo_labels = false
end
