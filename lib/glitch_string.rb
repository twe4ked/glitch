module Glitch
  class GlitchString
    # http://en.wikipedia.org/wiki/Combining_Diacritical_Marks
    COMBINING_DIACRITICAL_MARKS = ("\u0300".."\u036F").to_a

    def glitch(string, amount = 1, random = false, index_offset = 0)
      result = string.chars.map.each_with_index do |char, index|
        index = index + index_offset
        srand(string.chars.map(&:ord).join.to_i + index + (random ? Time.now.to_i : 0))

        add_mark = case amount
        when 1
          index % 5 == 0
        when 2
          index % 4 == 0
        when 3
          index % 3 == 0
        when 4
          index % 3 == 0
        when 5
          true
        else
          raise 'invalid amount (0..5)'
        end

        case char
        when ' '
          char
        else
          if add_mark
            mark = COMBINING_DIACRITICAL_MARKS.sample
            char + mark
          else
            char
          end
        end
      end.join

      case amount
      when 2
        glitch result, 1, random, amount
      when 3
        glitch result, 2, random, amount
      when 4
        glitch result, 3, random, amount
      when 5
        glitch result, 4, random, amount
      else
        result
      end
    end
  end
end
