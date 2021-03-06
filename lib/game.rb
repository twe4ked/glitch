require 'curses'
require 'pstore'

module Glitch
  class Game
    DATA_FILE = File.expand_path('~/.glitch-game')

    def initialize
      @player = Glitch::Player.new data.transaction { data[:bits] }
      @multiplier = data.transaction { data.fetch :multiplier, 0 }
      @last_second = 0
      @type_container = Glitch::TypeContainer.new data
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
      trap('SIGINT') {
        save_data
        exit
      }

      draw_screen

      Curses.curs_set 0
      Curses.timeout = 1000
      Curses.start_color

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
          type = @type_container.types[input]

          case
          when !type.available?
            add_message 'none left :('
          when @player.can_decrement_bits_by?(type.price)
            @player.decrement_bits type.price
            type.increment
            @multiplier = @multiplier + type.multiplier
            add_message "1 #{type.name}"
          else
            add_message "you've not enough bits for #{type.name}"
          end
        else
          add_message 'nope'
        end
      end

      # only once per second
      this_second = Time.now.to_i
      if this_second > @last_second
        @player.increment_bits 1 * @multiplier
        save_data
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

      if @type_container.types['c'].count == 1
        print_glitch_string 'clock: ', 1, false
        print_glitch_string Time.now.to_s
      end

      @one_bit = true if !@one_bit && @player.bits > 0
      if @one_bit
        print_glitch_string 'bits: ', 1, false
        print_glitch_string @player.bits.to_s + (@multiplier > 5 ? " (#{@multiplier}/bps)" : '')
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
          print_type_info = -> (*args) {
            Curses.addstr '- '
            print_glitch_string type.info_string, 1, false
            print_glitch_string " - #{type.description}"
          }

          if @player.can_decrement_bits_by?(type.price) && type.available?
            print_type_info.call
          else
            Curses.attron(Curses.color_pair(8)|Curses::A_BOLD, &print_type_info)
          end
        end
      end
    end

    def available_types
      @type_container.types.values.select do |type|
        @player.can_decrement_bits_by?(type.price - type.price/100.0*10) || type.count > 0
      end
    end

    def message_board_length
      @message_board_length + 10 * (@type_container.types['b'].count + 1)
    end

    def print_glitch_string(string, amount = 1, line_break = true, random = false)
      string = Glitch::GlitchString.new.glitch(string, amount, random)
      Curses.addstr string
      print_line_break if line_break
    end

    def print_line_break
      Curses.addstr "\n"
    end

    def data
      @data ||= PStore.new DATA_FILE
    end

    def save_data
      data.transaction do
        data[:bits] = @player.bits
        data[:multiplier] = @multiplier
        data[:types] = @type_container.types.values
      end
    end
  end
end
