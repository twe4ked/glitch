module Glitch
  class BoardType < Type
    def initialize
      super('board',
        initial_price: 500,
        multiplier: 0,
        count_available: 4
      )
    end

    def price
      [
        self.initial_price * (self.count + 1),
        2000
      ].min
    end
  end
end
