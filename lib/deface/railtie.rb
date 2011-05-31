module Deface
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join([File.dirname(__FILE__) , "../../tasks/deface.rake"])
    end
  end
end
