module Deface
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join([File.dirname(__FILE__) , "../../tasks/deface.rake"])
    end

    initializer "deface.environment" do |app|
      app.config.deface = Deface::Environment.new
      app.config.deface.overrides.early_check
    end
  end
end
