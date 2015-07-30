require 'board'

describe Board do
  let(:ship) { double :ship }
  before { allow(ship).to receive(:size) }

  it 'places a ship' do
    subject.place ship, 1, :a3, :horizontal
    expect(subject.placed_ships).not_to be_empty
  end

  it 'only allows placement within limits of board' do
    expect { subject.place ship, 1, :a12, :horizontal } .to raise_error ('Off Grid')
  end

  it 'registers hits' do
    allow(ship).to receive(:hit)
    subject.place ship, 1,:a3, :horizontal
    expect(subject.fire :a3).to eq 'Hit'
  end

  it "won't allow hits on same spot twice" do
    allow(ship).to receive(:hit)
    subject.place ship, 1, :a3, :horizontal
    subject.fire :a3
    expect { subject.fire :a3 }.to raise_error ('Already fired on')
  end

  it 'gets the next horizontal coords' do
    expect(subject.get_coords(:a1, 2, :horizontal)).to eq [:a1, :b1]
  end
end
