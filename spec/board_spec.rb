require 'board'

describe Board do
  # before{     allow(ship).to receive(:lose_hp)}
  let(:ship) { double :ship }

  it 'places a ship' do
    subject.place ship, :a3
    expect(subject.placed_ships).not_to be_empty
  end

  it "only allows placement within limits of board" do
    expect{subject.place ship, :a12}.to raise_error ("NO WAY! You're off the freaking grid!!!!")
  end

  it 'registers hits' do
    allow(ship).to receive(:hit)
    subject.place ship, :a3
    expect(subject.fire :a3).to eq 'Hit'
  end

  it "won't allow hits on same spot twice" do
    allow(ship).to receive(:hit)
    subject.place ship, :a3
    subject.fire :a3
    expect{ subject.fire :a3 }.to raise_error ("Already fired on")
  end

  it 'reduces hp on hits' do
    allow(ship).to receive(:hit)
    subject.place ship, :a3
    expect(subject.placed_ships[:a3]).to receive(:hit)
    subject.fire :a3
  end
end