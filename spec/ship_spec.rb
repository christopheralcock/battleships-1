require 'ship'

describe Ship do
  it 'initializes with any size' do
    subject = described_class.new(3)
    expect(subject.size).to eq 3
  end

  it 'hp is same as size' do
    subject = described_class.new(5)
    expect(subject.hp).to eq 5
  end
end
