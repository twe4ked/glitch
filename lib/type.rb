module Glitch
  class Type
    attr_reader :name, :multiplier, :count, :initial_price

    def initialize(name, options = {})
      @name = name
      @initial_price = options[:initial_price]
      @multiplier = options[:multiplier]
      @count_available = options[:count_available] || :infinite
      @price_calc = options[:price_calc]
      @description = options[:description]
      @count = 0
    end

    def shortcut
      @name[0]
    end

    def name_with_shortcut
      @name.sub(shortcut, "[#{shortcut}]")
    end

    def price
      if @price_calc
        @price_calc.call(self)
      else
        [
          @initial_price,
          @initial_price * @count * (@count >= 10 ? 10 : 1) + @count
        ].max
      end
    end

    def increment
      @count = @count + 1
      if @count_available.is_a? Integer
        @count_available = @count_available - 1
      end
    end

    def available?
      infinite? || @count_available > 0
    end

    def total_available
      if infinite?
        '??'
      else
        @count + @count_available
      end
    end

    def info_string
      string = []
      string << name_with_shortcut
      string << "[#{price} bits]"
      string << "(#{@count}/#{total_available})" if @count > 0
      string << "*#{@multiplier}"
      string.join ' '
    end

    def description
      @description || '??'
    end

    private

    def infinite?
      @count_available == :infinite
    end
  end
end
