require 'deface'

namespace :deface do
  include Deface::TemplateHelper

  desc 'Applies selectors to given partial/template, and returns match(s) source.'
  task :test_selector, [:virtual_path, :selector] => [:environment] do |t, args|

    begin
      source = load_template_source(args[:virtual_path], false)
      output = element_source(source, args[:selector])
    rescue
      puts "Failed to find tempalte/partial"

      output = []
    end

    if output.empty?
      puts "0 matches found"
    else
      puts "Querying '#{args[:virtual_path]}' for '#{args[:selector]}'"
      output.each_with_index do |content, i|
        puts "---------------- Match #{i+1} ----------------"
        puts content
      end
    end

  end


  desc 'Get the resulting markup for a partial/template'
  task :get_result, [:virtual_path] => [:environment] do |t,args|
    puts "---------------- Before ----------------"
    puts load_template_source(args[:virtual_path], false, false)
    puts ""

    overrides = Deface::Override.find(:virtual_path => args[:virtual_path])
    puts "---------------- Overrides (#{overrides.size})--------"
    overrides.each do |override|
      puts "- '#{override.name}' will#{ ' NOT' if override.args[:disabled]} be applied."
    end
    puts ""

    puts "---------------- After ----------------"
    puts load_template_source(args[:virtual_path], false, true)

  end

end
