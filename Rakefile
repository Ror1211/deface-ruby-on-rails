require 'rake'
require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rspec'
require 'rspec/core/rake_task'

desc 'Default: run specs'
task :default => :spec  
Rspec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end
