require 'curses'

module Glitch
  class Game
    def initialize
      @player = Glitch::Player.new
      @bit_multiplier = 0
      @last_second = 0

      @types = {}
      [
        Glitch::Type.new('atom', initial_price: 10, multiplier: 1, count_available: 20),
        Glitch::Type.new('uber', initial_price: 100, multiplier: 10),
        Glitch::Type.new('matrix', initial_price: 150, multiplier: 11),
        Glitch::Type.new('hundo', initial_price: 99999, multiplier: 100),
        Glitch::Type.new('board', initial_price: 500, multiplier: 0, count_available: 4),
        Glitch::Type.new('clock', initial_price: 1337, multiplier: 0, count_available: 1, price_calc: -> (type) { type.initial_price }),
      ].each { |type| @types[type.shortcut] = type }

      @message_board_length = 30
      @messages = [
        'welcome to glitch',
        'you need bits',
        "you're not sure why",
        'you know you do',
        'survive...',
      ]
    end

    def self.run
      self.new.run
    end

    def run
      draw_screen

      Curses.curs_set 0
      Curses.timeout = 1000

      loop do
        tick
      end
    end

    def tick
      input = Curses.getch

      if input
        case
        when input == ' '
          @player.increment_bits
          add_message '1 bit'
        when available_types.map(&:shortcut).include?(input)
          type = @types[input]

          case
          when !type.available?
            add_message 'none left :('
          when @player.can_decrement_bits_by?(type.price)
            @player.decrement_bits type.price
            type.increment
            @bit_multiplier = @bit_multiplier + type.multiplier
            add_message "1 #{type.name}"
          when type.count > 0
            add_message "you've not enough bits for #{type.name}"
          end
        else
          add_message 'nope'
        end
      end

      # only once per second
      this_second = Time.now.to_i
      if this_second > @last_second
        @player.increment_bits 1 * @bit_multiplier
        @last_second = this_second
      end

      @messages = @messages.last(10)

      draw_screen
    end

    def draw_screen
      Curses.clear

      print_line_break
      print_glitch_string 'glitch!', 5
      print_line_break

      if @types['c'].count == 1
        print_glitch_string 'clock: ', 1, false
        print_glitch_string Time.now.to_s
      end

      @one_bit = true if !@one_bit && @player.bits > 0
      if @one_bit
        print_glitch_string 'bits: ', 1, false
        print_glitch_string @player.bits.to_s + (@bit_multiplier > 5 ? " (#{@bit_multiplier}/bps)" : '')
        print_line_break
      end

      print_glitch_string '-' * message_board_length
      if @messages
        @messages.each do |message|
          print_glitch_string message[0..message_board_length-4], 3, false
          if message.length > message_board_length-4
            Curses.addstr '...'
          end
          print_line_break
        end
      else
        print_glitch_string '...', 1, true, true
      end
      print_glitch_string '-' * message_board_length

      draw_types

      print_line_break
      Curses.addstr ':'
    end

    private

    def add_message(message)
      @messages << message
    end

    def draw_types
      unless available_types.empty?
        print_line_break
        available_types.each do |type|
          Curses.addstr '- '
          print_glitch_string type.info_string
        end
      end
    end

    def available_types
      @types.values.select do |type|
        @player.can_decrement_bits_by?(type.price) || type.count > 0
      end
    end

    def message_board_length
      @message_board_length + 10 * (@types['b'].count + 1)
    end

    def print_glitch_string(string, amount = 1, line_break = true, random = false)
      string = Glitch::GlitchString.new.glitch(string, amount, random)
      Curses.addstr string
      print_line_break if line_break
    end

    def print_line_break
      Curses.addstr "\n"
    end
  end
end
