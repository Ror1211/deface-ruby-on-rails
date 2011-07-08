module Deface
  module TemplateHelper

    # used to find source for a partial or template using virutal_path
    def load_template_source(virtual_path, partial, include_overrides=true)
      parts = virtual_path.split("/")
      prefix = []
      if parts.size == 2
        prefix << ""
        name = virtual_path
      else
        prefix << parts.shift
        name = parts.join("/")
      end

      @lookup_context ||= ActionView::LookupContext.new(ActionController::Base.view_paths, {:formats => [:html]})

      source = @lookup_context.find(name, prefix, partial).source

      if include_overrides
        Deface::Override.apply(source, {:virtual_path => virtual_path})
      else
        source
      end
    end

    #gets source erb for an element
    def element_source(template_source, selector)
      doc = Deface::Parser.convert(template_source)

      doc.css(selector).inject([]) do |result, match|
        result << Deface::Parser.undo_erb_markup!(match.to_s.dup)
      end
    end
  end
end
