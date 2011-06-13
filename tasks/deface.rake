namespace :deface do
  desc 'Gets source of html element from template.'
  task :get_source, [:template_path, :selector] => [:environment] do |t, args|
    include Deface::TemplateHelper

    begin
      source = load_template_source(args[:template_path], false)
      output = element_source(source, args[:selector])
    rescue
      puts "Failed to find tempalte/partial"

      output = []
    end

    if output.empty?
      puts "0 matches found"
    else
      puts "Querying '#{args[:template_path]}' for '#{args[:selector]}'"
      output.each_with_index do |content, i|
        puts "---------------- Match #{i+1} ----------------"
        puts content
      end
    end

  end
end
