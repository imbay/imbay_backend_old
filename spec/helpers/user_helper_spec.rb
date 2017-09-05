require 'rails_helper'

RSpec.describe UserHelper, type: :helper do
  it "to russian" do
    expect(to_russian('Нұрасыл')).to eq 'Нурасыл'
  end
  it "to english" do
    expect(to_english('Нұрасыл')).to eq 'Nurasyl'
    expect(to_english('Әйгерім')).to eq 'Aigerim'
    expect(to_english('Гаухар')).to eq 'Gaukhar'
  end
  it "is ID?" do
    expect(is_id?(" 1 ")).to be true
    expect(is_id?(" 1.5 ")).to be false
  end
end
