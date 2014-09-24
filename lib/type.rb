module Glitch
  class Type
    attr_reader :name, :multiplier, :count, :initial_price
    attr_accessor :container

    def initialize(name, options = {})
      @name = name
      @initial_price = options[:initial_price]
      @multiplier = options[:multiplier]
      @count_available = options[:count_available] || :infinite
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
      [
        @initial_price,
        @initial_price * @count * (@count >= 10 ? 10 : 1) + @count
      ].max
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
      %i[
        name_with_shortcut
        price_display
        count_display
        multiplier_display
      ].each do |method|
        max_length = max_string_length(types.map(&method))
        string << format_string_pad(max_length) % send(method)
      end
      string.join ' '
    end

    def description
      @description || '??'
    end

    def price_display
      "[#{price} bits]"
    end

    def count_display
      if @count > 0
        "(#{@count}/#{total_available})"
      else
        ''
      end
    end

    def multiplier_display
      "*#{@multiplier}"
    end

    private

    def types
      @container && @container.types.values || []
    end

    def format_string_pad(length)
      "%-#{length}.#{length}s"
    end

    def max_string_length(strings)
      strings.inject(0) { |l, s| s.length > l && l = s.length; l }
    end

    def infinite?
      @count_available == :infinite
    end
  end
end
