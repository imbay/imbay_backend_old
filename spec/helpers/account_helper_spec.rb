require 'rails_helper'

RSpec.describe AccountHelper, type: :helper do
  context "| normalizer" do
    normalizer = AccountHelper::Normalizer.new
    it "| username" do
      expect(normalizer.username(" Nurasyl ")).to eq "nurasyl"
    end
    it "| first_name" do
      expect(normalizer.first_name(" нұр асыл ")).to eq "Нұрасыл"
    end
    it "| last_name" do
      expect(normalizer.last_name(" ал дан ")).to eq "Алдан"
    end
    it "| gender" do
      expect(normalizer.gender(" 0 ")).to eq 0
      expect(normalizer.gender(" 1 ")).to eq 1
      expect(normalizer.gender("1")).to eq 1
    end
    it "| email" do
      expect(normalizer.email(" Nurassyl.Aldan@gmail.com ")).to eq "nurassyl.aldan@gmail.com"
    end
    it "| password" do
      expect(normalizer.password(" my password ")).to eq "my password"
    end
    it "| language" do
      expect(normalizer.language("es")).to eq normalizer.config.default[:language]
      expect(normalizer.language("kk")).to eq "kk"
      expect(normalizer.language("ru")).to eq "ru"
    end
    it "| balance" do
      expect(normalizer.balance(" 2 000 000 ")).to eq 2000000
      expect(normalizer.balance(" ")).to eq 0
      expect(normalizer.balance(" - 1")).to eq -1
      expect(normalizer.balance(" + 1 . 0")).to eq 1
      expect(normalizer.balance("5.5")).to eq 5
    end
  end
  context "| format" do
    config = AccountHelper::Configuration.new
    it "| username" do
      expect("nurasyl".match(config.format[:username]) != nil).to be true
      expect("nur asyl".match(config.format[:username]) != nil).to be false
      expect("_nurasyl".match(config.format[:username]) != nil).to be false
      expect("nurasyl_".match(config.format[:username]) != nil).to be false
      expect("nurasyl_aldan".match(config.format[:username]) != nil).to be true
      expect("nurasyl_aldan_21".match(config.format[:username]) != nil).to be true
      expect("21nurasyl".match(config.format[:username]) != nil).to be true
      expect("nurasyl11".match(config.format[:username]) != nil).to be true
      expect("a_nurasyl".match(config.format[:username]) != nil).to be true
      expect("n_aldan".match(config.format[:username]) != nil).to be true
      expect("12345".match(config.format[:username]) != nil).to be false
      expect("___".match(config.format[:username]) != nil).to be false
      expect("21_11_1996".match(config.format[:username]) != nil).to be true
      expect("nurasyl__aldan".match(config.format[:username]) != nil).to be false
    end
    it "| email" do
      expect("nurassyl.aldan@gmail.com".match(config.format[:email]) != nil).to be true
      expect("nurasyl".match(config.format[:email]) != nil).to be false
      expect("_@_".match(config.format[:email]) != nil).to be true
      expect("_-@_".match(config.format[:email]) != nil).to be true
      expect("nurasyl-aldan@localhost".match(config.format[:email]) != nil).to be true
      expect("nurasyl-aldan@".match(config.format[:email]) != nil).to be false
      expect("@domain".match(config.format[:email]) != nil).to be false
    end
  end
end
