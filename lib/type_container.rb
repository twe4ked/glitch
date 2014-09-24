module Glitch
  class TypeContainer
    attr_reader :types

    def initialize(data)
      @types = data.transaction { data.fetch :types, default_types }.inject({}) do |types, type|
        type.container = self
        types[type.shortcut] = type
        types
      end
    end

    private

    def default_types
      [
        Glitch::Type.new('atom', initial_price: 10, multiplier: 1, count_available: 20, :description => 'a boring little atom, so lonely'),
        Glitch::Type.new('uber', initial_price: 100, multiplier: 10),
        Glitch::Type.new('matrix', initial_price: 150, multiplier: 11),
        Glitch::Type.new('hundo', initial_price: 99999, multiplier: 100),
        Glitch::BoardType.new,
        Glitch::ClockType.new,
      ]
    end
  end
end
