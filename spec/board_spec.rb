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

  it 'only allows placement within limits of board' do
    expect { subject.place ship3, :a12, :horizontal } .to raise_error ('Off Grid')
  end

  it 'registers hits' do
    subject.place ship3, :a3, :horizontal
    expect(subject.fire :a3).to eq 'Hit'
  end

  it "won't allow hits on same spot twice" do
    subject.place ship3, :a3, :horizontal
    subject.fire :a3
    expect { subject.fire :a3 }.to raise_error ('Already fired on')
  end

  it 'gets the next horizontal coords' do
    expect(subject.get_coords(ship3, :a1, :horizontal)).to eq [:a1, :b1, :c1]
  end

  it "won't allow a ship to be overwritten" do
    subject.place ship3, :a1, :horizontal
    expect { subject.place ship3, :a1, :horizontal }.to raise_error ('Coordinates already occupied')
  end

  it "knows if a coord doesn't have a ship on it" do
    expect(subject.has_ship? :a1).to eq false
  end

  it 'knows if a coord has a ship on it' do
    allow(subject).to receive(:placed_ships).and_return({ :a1 => ship1 })
    expect(subject.has_ship? :a1).to eq true
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
end
