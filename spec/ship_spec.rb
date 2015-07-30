require 'ship'

describe Ship do
  it 'initializes with any size' do
    subject = described_class.new(3)
    expect(subject.size).to eq 3
  end

  it 'expect ships which receive a hit to lose HP' do
    ship = Ship.new 1
    expect(ship.hit).to eq 1
  end
end
