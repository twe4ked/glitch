require 'tempfile'
require_relative '../../lib/game'
require_relative '../../lib/player'
require_relative '../../lib/type'
require_relative '../../lib/type_container'
require_relative '../../lib/glitch/types/board_type'
require_relative '../../lib/glitch/types/clock_type'

describe Glitch::Type do
  let(:game) { Glitch::Game.new }
  let(:data_file) { Tempfile.new 'data_file' }

  after do
    data_file.close!
  end

  it 'sets up a game using default values' do
    stub_const 'Glitch::Game::DATA_FILE', data_file.path

    expect(game.instance_variable_get('@player').bits).to eq 0
    expect(game.instance_variable_get('@multiplier')).to eq 0
    expect(game.instance_variable_get('@type_container').types.values.map(&:count).uniq).to eq [0]
  end

  it 'sets up a game using existing data from the data file' do
    types = Glitch::Game.new.instance_variable_get('@type_container').types.values.tap do |types|
      types.each_with_index do |type, index|
        type.instance_variable_set('@count', index)
      end
    end

    data = PStore.new data_file.path
    data.transaction do
      data[:bits] = 42
      data[:multiplier] = 84
      data[:types] = types
    end

    stub_const 'Glitch::Game::DATA_FILE', data_file.path

    expect(game.instance_variable_get('@player').bits).to eq 42
    expect(game.instance_variable_get('@multiplier')).to eq 84
    expect(game.instance_variable_get('@type_container').types.values.map(&:count).uniq).to eq (0...types.count).to_a
  end
end
