module Glitch
  class Player
    attr_reader :bits

    def initialize
      @bits = 0
    end

    def increment_bits(number = 1)
      @bits = @bits + number
    end

    def can_decrement_bits_by?(number)
      @bits >= number
    end

    def decrement_bits(number)
      @bits = @bits - number
    end
  end
end
