require 'rails_helper'

RSpec.configure do |c|
    c.use_transactional_examples = false
    c.order = "defined"
end

RSpec.describe Account, type: :model do
  context "| validator" do
    it "| create" do
    time = Time.now.getutc.strftime('%s')
    account = Account.new
    account.username = "nurasyl"
    account.password = "123456"
    account.joined_time = $time
    account.login_time = $time
    account.language = "es"
    account.inviter = "1"
    account.first_name = "Nurasyl"
    account.last_name = "Aldan"
    account.gender = 1
    account.birthday = "21.11.1996"
    account.joined_ip = "127.0.0.1"
    account.logged_ip = "127.0.0.1"

    expect(account.valid?).to be true
    end
    after(:all) { Account.destroy_all }
  end
end
