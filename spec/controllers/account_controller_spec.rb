require 'rails_helper'
$session_key = nil

RSpec.configure do |c|
    c.use_transactional_examples = false
    c.order = "defined"
end

RSpec.describe AccountController, type: :controller do
    it "| sign up" do
        post :sign_up, :params => { :username => "nurasyl", :password => "123456", :language => "es", :inviter => "", :first_name => "nurasyl", :last_name => "aldan", :gender => "1", :birthday => "21.11.1996" }
        res = JSON.parse(response.body)
        $session_key = res['session_key']
        expect(res['error']).to eq 0
    end
    it "| sign in valid" do
        post :sign_in, :params => { :session_key => $session_key, :username => " Nurasyl ", :password => " 123456 "}
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
    end
    it "| sign in invalid username" do
        post :sign_in, :params => { :session_key => $session_key, :username => " Gaukhar ", :password => " 123456 "}
        res = JSON.parse(response.body)
        expect(res['error']).to eq 2
    end
    it "| sign in invalid password" do
        post :sign_in, :params => { :session_key => $session_key, :username => " Nurasyl ", :password => " 1234567 "}
        res = JSON.parse(response.body)
        expect(res['error']).to eq 2
    end
    it "| update email" do
        post :update_email, :params => { :session_key => $session_key, :email => " Gaukhar.Abylkasym@gmail.com " }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
    end
    it "| update username" do
        post :update_username, :params => { :session_key => $session_key, :username => " Gaukhar " }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
    end
    it "| update password" do
        post :update_password, :params => { :session_key => $session_key, :password => " 123456 " }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
    end
    it "| update language" do
        post :update_language, :params => { :session_key => $session_key, :language => " es " }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
    end
    it "| unactive" do
        post :unactive, :params => { :session_key => $session_key }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
        expect(res['body']).to be false
    end
    it "| active" do
        post :active, :params => { :session_key => $session_key }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
        expect(res['body']).to be true
    end
    it "| update" do
        post :update, :params => { :session_key => $session_key, :first_name => " gaukhar ", :last_name => " abylkasymova ", :gender => " 0 ", :birthday => "14.06.2001" }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
        expect(res['body']['first_name']).to eq "Gaukhar"
    end
    it "| sign out" do
        post :sign_out, :params => { :session_key => $session_key }
        res = JSON.parse(response.body)
        expect(res['error']).to eq 0
    end
    after(:all) { Account.destroy_all }
end
