require 'rails_helper'

RSpec.describe DialogController, type: :controller do
  $dialog_id = nil
  it "| new dialog" do
      post :new_dialog, :params => { :session_key => $session_key, :title => "My title", :is_anon => "0" }
      res = JSON.parse(response.body)
      $dialog_id = res['body']['id']
      expect(res['error']).to eq 0
  end
  it "| my dialogs" do
      post :my_dialogs, :params => { :session_key => $session_key }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 0
  end
  it "| dialogs" do
      post :dialogs, :params => { :session_key => $session_key }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 0
  end
  it "| new user" do
      post :new_user, :params => { :session_key => $session_key, :dialog_id => 0, :user_id => "1" }
      res = JSON.parse(response.body)
      # dialog is not found.
      expect(res['error']).to eq 4

      post :new_user, :params => { :session_key => $session_key, :dialog_id => $dialog_id, :user_id => "0" }
      res = JSON.parse(response.body)
      # user is not found.
      expect(res['error']).to eq 3

      post :new_user, :params => { :session_key => $session_key, :dialog_id => $dialog_id, :user_id => $user_id }
      res = JSON.parse(response.body)
      # user is exists.
      expect(res['error']).to eq 3
  end
  it "| users" do
      post :users, :params => { :session_key => $session_key, :dialog_id => 0, :user_id => $user_id }
      res = JSON.parse(response.body)
      # dialog is not found.
      expect(res['error']).to eq 4

      post :users, :params => { :session_key => $session_key, :dialog_id => $dialog_id, :user_id => $user_id }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 0
  end
  it "| delete user" do
      post :delete_user, :params => { :session_key => $session_key, :dialog_id => 0, :user_id => $user_id }
      res = JSON.parse(response.body)
      # dialog is not found.
      expect(res['error']).to eq 4

      post :delete_user, :params => { :session_key => $session_key, :dialog_id => $dialog_id, :user_id => $user_id }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 0
  end
  it "| quit_dialog" do
      post :quit_dialog, :params => { :session_key => $session_key, :dialog_id => 0, :user_id => $user_id }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 4
  end
  it "| delete dialog" do
      post :delete_dialog, :params => { :session_key => $session_key, :dialog_id => "0" }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 4
  end
  after(:all) { Account.destroy_all }
end
