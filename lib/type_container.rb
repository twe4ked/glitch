module Glitch
  class TypeContainer
    attr_reader :types

    def initialize(types)
      @types = types.inject({}) do |types, type|
        type.container = self
        types[type.shortcut] = type
        types
      end
    end
  end
end
