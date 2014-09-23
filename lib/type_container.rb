module Glitch
  class TypeContainer
    attr_reader :types

    def initialize(types)
      @types = Hash[types.map do |shortcut, type|
        type.container = self
        [shortcut, type]
      end]
    end
  end
end
