require 'board'

describe Board do
  let(:ship3) { double :ship }
  let(:ship1) { double :ship}
  before { allow(ship3).to receive(:size).and_return(3) }
  before { allow(ship1).to receive(:size).and_return(1) }
  before { allow(ship3).to receive(:sunk?) }
  before { allow(ship1).to receive(:sunk?) }
  before { allow(ship3).to receive(:hit) }
  before { allow(ship1).to receive(:hit) }

  it 'places a ship' do
    subject.place ship3, :a3, :horizontal
    expect(subject.placed_ships).not_to be_empty
  end

  it 'gets the next horizontal coords' do
    expect(subject.next_horizontal(:a1)).to eq :b1
  end

  it 'gets the next vertical coords' do
    expect(subject.next_vertical(:a1)).to eq :a2
  end

  it 'gets the next coords' do
    expect(subject.get_coords(ship3, :a3, :horizontal)).to eq [:a3, :b3, :c3]
  end

  it 'only allows placement within limits of board' do
    expect { subject.place ship3, :a12, :horizontal } .to raise_error ('Off Grid')
  end

  it "won't allow ships to overlap" do
    subject.place ship3, :a1, :horizontal
    expect { subject.place ship3, :a1, :horizontal }.to raise_error ('Coordinates already occupied')
  end

  it 'says hit' do
    subject.place ship3, :a3, :horizontal
    expect(subject.fire :a3).to eq 'Hit'
  end

  it 'says miss' do
    subject.place ship3, :a3, :horizontal
    expect(subject.fire :a4).to eq 'Miss'
  end

  it 'registers hits' do
    subject.place ship1, :a3, :horizontal
    subject.fire :a3
    expect(subject.number_of_hits).to eq [:a3]
  end

  it 'registers misses' do
    subject.place ship1, :a3, :horizontal
    subject.fire :j1
    expect(subject.number_of_misses).to eq [:j1]
  end

  it "won't allow hits on same spot twice" do
    subject.place ship3, :a3, :horizontal
    subject.fire :a3
    expect { subject.fire :a3 }.to raise_error ('Already fired on')
  end

  it "knows if a coord doesn't have a ship on it" do
    expect(subject.ship? :a1).to eq false
  end

  it 'knows if a coord has a ship on it' do
    allow(subject).to receive(:placed_ships).and_return({ :a1 => ship1 })
    expect(subject.ship? :a1).to eq true
  end

  it 'says you\'ve sunk a ship' do
    subject.place ship1, :a1, :horizontal
    expect(ship1).to receive(:sunk?)
    subject.fire :a1
  end

  it 'know game is not over before starting' do
    expect(subject.victory?).to eq false
  end

  it 'know game is over if all ships have sunk' do
    subject.place ship1, :a1, :horizontal
    allow(ship1).to receive(:sunk?).and_return(true)
    subject.fire :a1
    expect(subject.victory?).to eq true
  end

  it 'correctly deletes ship from board' do
    allow(ship1).to receive(:ships_on_board).and_return(ship1)
    subject.sunk_ship ship1
    expect(subject.ships_on_board).to be_empty
  end
end
