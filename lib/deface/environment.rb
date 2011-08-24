module Deface

  class Environment
    attr_accessor :overrides
    def initialize
      @overrides = Overrides.new
    end
  end

  class Environment::Overrides
    attr_accessor :all

    def initialize
      @all = {}
    end

    def find(*args)
      Deface::Override.find(*args)
    end
  end
end

