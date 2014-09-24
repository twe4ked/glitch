require_relative '../../lib/type'
require_relative '../../lib/type_container'

describe Glitch::TypeContainer do
  let(:type_foo) { Glitch::Type.new 'foo', initial_price: 10, multiplier: 1 }
  let(:type_bar) { Glitch::Type.new 'bar', initial_price: 10, multiplier: 1 }
  let(:container) { Glitch::TypeContainer.new [type_foo, type_bar] }

  describe '#types' do
    it 'sets the container of every type' do
      expect(container.types.values.map(&:container)).to eq [container, container]
    end

    it 'returns a hash with the shortcut of each type as the key' do
      expect(container.types).to eq({
        'f' => type_foo,
        'b' => type_bar,
      })
    end
  end
end
