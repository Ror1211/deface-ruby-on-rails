ActionView::Template.class_eval do
  alias_method :rails_initialize, :initialize

  def initialize(source, identifier, handler, details)
    if Rails.application.config.deface.enabled
      if handler.to_s == "Haml::Plugin"
        haml = true
      end

      processed_source = Deface::Override.apply(source, details, true, haml )

      if haml && processed_source != source
        handler = ActionView::Template::Handlers::ERB
      end
    else
      processed_source = source
    end

    rails_initialize(processed_source, identifier, handler, details)
  end
end

#fix for Rails 3.1 not setting virutal_path anymore (BOO!)
if defined?(ActionView::Resolver::Path)
  ActionView::Resolver::Path.class_eval { alias_method :virtual, :to_s }
end
