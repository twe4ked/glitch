require_relative '../../lib/player.rb'

describe Glitch::Player do
  let(:player) { Glitch::Player.new }

  describe '#increment_bits' do
    it 'increments by 1 if no argument is supplied' do
      expect { player.increment_bits }.to change { player.bits }.from(0).to(1)
      expect { player.increment_bits }.to change { player.bits }.from(1).to(2)
    end

    it 'increments by the number supplied as an argument' do
      player.increment_bits
      expect { player.increment_bits 41 }.to change { player.bits }.from(1).to(42)
    end
  end

  describe '#can_decrement_bits_by?' do
    it 'returns true if the player has enough bits' do
      expect(player.can_decrement_bits_by? 0).to eq true
      player.increment_bits
      expect(player.can_decrement_bits_by? 1).to eq true
    end

    it "returns false if the player doesn't have enough bits" do
      expect(player.can_decrement_bits_by? 42).to eq false
    end
  end

  describe 'decrement_bits' do
    it 'decrements bits by the number supplied' do
      player.increment_bits
      expect { player.decrement_bits 1 }.to change { player.bits }.from(1).to(0)
    end
  end
end
