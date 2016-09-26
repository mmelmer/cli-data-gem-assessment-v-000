require 'spec_helper'

describe NewGem do
  it 'has a version number' do
    expect(NewGem::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
