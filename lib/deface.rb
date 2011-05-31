require "action_view"
require "action_controller"
require "deface/action_view_extensions"
require "deface/template_helper"
require "deface/override"
require "deface/parser"

module Deface
  require 'deface/railtie' if defined?(Rails)
end
