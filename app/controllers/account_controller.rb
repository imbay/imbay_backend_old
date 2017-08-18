class AccountController < ApplicationController
  include AccountHelper
  before_action :init_controller

  def init_controller
    @normalizer = AccountHelper::Normalizer.new
    @response = {
      :error => 1,
      :body => nil
    }
    if @current_user.nil?
      @response[:error] = 2
    end
  end

  def sign_up
    account = Account.new

    account.username = params[:username]
    account.password = params[:password]
    account.joined_time = $time
    account.login_time = $time
    account.language = params[:language]
    account.inviter = params[:inviter]

    account.first_name = params[:first_name]
    account.last_name = params[:last_name]
    account.gender = params[:gender]
    account.birthday = params[:birthday]

    account.joined_ip = request.remote_addr
    account.logged_ip = request.remote_addr

    if account.invalid?
      @response[:error] = 3
      @response[:body] = account.errors.messages
    elsif account.valid? && account.save
      login(account)
      @response[:error] = 0
      @response[:body] = account
    end

    render json: @response
  end
end
