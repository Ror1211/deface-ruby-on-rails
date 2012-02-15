require 'polyglot'

require 'deface/dsl/context'

module Deface
  module DSL
    class Loader
      def self.load(filename, options = nil, &block)
        File.open(filename) do |file|
          name = File.basename(filename).gsub('.deface', '')
          context = Context.new(name)
          context.instance_eval(file.read)
          context.create_override
        end
      end

      def self.register
        Polyglot.register('deface', self)
      end
    end
  end
end