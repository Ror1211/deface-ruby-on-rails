module Deface
  module Sources
    class Cut < Source
      def self.execute(override)
        cut = override.args[:cut]
        if cut.is_a? Hash
          range = Deface::Matchers::Range.new('Cut', cut[:start], cut[:end]).matches(override.parsed_document).first
          range.map &:remove

          Deface::Parser.undo_erb_markup! range.map(&:to_s).join

        else
          Deface::Parser.undo_erb_markup! override.parsed_document.css(cut).first.remove.to_s.clone
        end
      end
    end
  end
end
