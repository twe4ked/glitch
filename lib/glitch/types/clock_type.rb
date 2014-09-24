module Glitch
  class ClockType < Type
    def initialize
      super('clock',
        initial_price: 1337,
        multiplier: 0,
        count_available: 1
      )
    end

    def price
      self.initial_price
    end
  end
end
