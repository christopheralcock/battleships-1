require 'board'

describe Board do
  before{ allow(ship).to receive(:lose_hp) }
  let(:ship) { double :ship, initial_position: :a3, hp: 1 }

  it 'places a ship' do
    subject.place ship, :a3
    expect(subject.placed_ships).not_to be_empty
  end

  it 'registers hits' do
    subject.place ship, :a3
    expect(subject.fire :a3).to eq 'Hit'
  end

  it 'reduces hp on hits' do
    subject.place ship, :a3
    subject.fire :a3
    expect(subject.placed_ships[:a3].hp).to eq 0
  end
end
