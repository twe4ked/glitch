require_relative '../../lib/type'

describe Glitch::Type do
  let(:type) { Glitch::Type.new 'foo', initial_price: 10, multiplier: 1 }

  describe '#shortcut' do
    it 'returns a single letter shortcut' do
      expect(type.shortcut).to eq 'f'
    end
  end

  describe '#name_with_shortcut' do
    it 'returns the name with the shortcut surrounded in brackets' do
      expect(type.name_with_shortcut).to eq '[f]oo'
    end
  end

  describe '#price' do
    it 'returns different amounts based on the count' do
      expect(type.price).to eq 10

      type.instance_variable_set('@count', 1)
      expect(type.price).to eq 11

      type.instance_variable_set('@count', 9)
      expect(type.price).to eq 99

      type.instance_variable_set('@count', 10)
      expect(type.price).to eq 1010

      type.instance_variable_set('@count', 11)
      expect(type.price).to eq 1111

      type.instance_variable_set('@count', 99)
      expect(type.price).to eq 9999

      type.instance_variable_set('@count', 100)
      expect(type.price).to eq 10100
    end
  end

  describe '#increment' do
    it 'increments the count' do
      expect { type.increment }.to change { type.count }.from(0).to(1)
      expect { type.increment }.to change { type.count }.from(1).to(2)
    end
  end
end
