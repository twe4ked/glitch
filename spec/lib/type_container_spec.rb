require_relative '../../lib/type.rb'
require_relative '../../lib/type_container.rb'

describe Glitch::TypeContainer do
  let(:type_foo) { Glitch::Type.new 'foo', initial_price: 10, multiplier: 1 }
  let(:type_bar) { Glitch::Type.new 'bar', initial_price: 10, multiplier: 1 }

  describe '#types' do
    it 'sets the container of every type' do
      types_hash = {
        'f' => type_foo,
        'b' => type_bar,
      }
      container = Glitch::TypeContainer.new types_hash

      expect(container.types).to eq types_hash
      expect(container.types.values.map(&:container)).to eq [container, container]
    end
  end
end
