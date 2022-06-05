# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:specs)

task default: :specs

task :spec do
  Rake::Task["specs"].invoke
  Rake::Task["rubocop"].invoke
  Rake::Task["spec_docs"].invoke
end

desc "Run RuboCop on the lib/specs directory"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ["lib/**/*.rb", "spec/**/*.rb"]
end

desc "Ensure that the plugin passes `danger plugins lint`"
task :spec_docs do
  sh "bundle exec danger plugins lint"
end

desc "Check the precoditions of the release flow"
task :check_release, [:version] do |_, args|
  new_version = args.version&.gsub(/\Av/, "") or raise "version argument is required"

  require_relative "lib/apkstats/gem_version"
  raise "Ver. #{Apkstats::VERSION} is defined but #{new_version} has been requested." unless Apkstats::VERSION == new_version
end
