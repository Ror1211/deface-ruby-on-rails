require 'polyglot'

require 'deface/dsl/context'

module Deface
  module DSL
    class Loader
      def self.load(filename, options = nil, &block)
        unless filename.end_with?('.html.erb.deface')
          raise "Deface::DSL does not know how to read '#{filename}'. Override files should end with .html.erb.deface"
        end

        unless file_in_dir_below_overrides?(filename)
          raise "Deface::DSL overrides must be in a sub-directory that matches the views virtual path. Move '#{filename}' into a sub-directory."
        end

        File.open(filename) do |file|
          context_name = File.basename(filename).gsub('.deface', '')

          file_contents = file.read

          if context_name.end_with?('.html.erb')
            dsl_commands, the_rest = extract_dsl_commands(file_contents)

            context_name = context_name.gsub('.html.erb', '')
            context = Context.new(context_name)
            context.instance_eval(dsl_commands)
            context.text(the_rest)
            context.virtual_path(determine_virtual_path(filename))
            context.create_override
          end
        end
      end

      def self.register
        Polyglot.register('deface', Deface::DSL::Loader)
      end

      def self.extract_dsl_commands(html_file_contents)
        dsl_commands = ''

        while starts_with_comment?(html_file_contents)
          first_open_comment_index = html_file_contents.lstrip.index('<!--')
          first_close_comment_index = html_file_contents.index('-->')
          if first_close_comment_index.nil?

          else
            comment = html_file_contents[first_open_comment_index..first_close_comment_index+2]
          end

          dsl_commands << comment.gsub('<!--', '').gsub('-->', '').strip + "\n"

          html_file_contents = html_file_contents.gsub(comment, '')
        end

        [dsl_commands, html_file_contents]
      end

      private 

      def self.starts_with_comment?(line)
        line.lstrip.index('<!--') == 0
      end

      def self.file_in_dir_below_overrides?(filename)
        File.fnmatch?("**/overrides/**/#{File.basename(filename)}", filename)
      end

      def self.determine_virtual_path(filename)
        result = ''
        pathname = Pathname.new(filename)
        pathname.ascend do |parent|
          if parent.basename.to_s == 'overrides'
            result = pathname.sub(parent.to_s + '/', '').dirname.to_s
            break
          end
        end
        result
      end
    end
  end
end
