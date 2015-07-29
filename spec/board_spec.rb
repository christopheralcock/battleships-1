require 'board'

describe Board do
  let(:ship) { double :ship }

  it 'places a ship' do
    subject.place ship, :a3
    expect(subject.board).not_to be_empty
  end

  it 'registers hits' do
    subject.place ship :a3
    expect(subject.fire :a3).to eq 'Hit'
  end
end
