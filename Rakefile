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


task :default => :spec

desc 'Generate documentation for the deface plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Spreme'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
