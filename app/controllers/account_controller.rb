class AccountController < ApplicationController
  include AccountHelper
  include SessionHelper
  before_action :init_session, :init_account, :init_controller

  def init_controller
    @normalizer = Normalizer.new
    @response = {
      :error => 1,
      :body => nil,
      :session_key => @session_key
    }
    if @current_user.nil?
      @response[:error] = 2
    end
  end

  def sign_up
    account = Account.new

    account.username = @normalizer.username params[:username]
    account.password = @normalizer.password params[:password]
    account.joined_time = $time
    account.login_time = $time
    account.language = @normalizer.language params[:language]
    account.inviter = @normalizer.inviter params[:inviter]

    account.first_name = @normalizer.first_name params[:first_name]
    account.last_name = @normalizer.last_name params[:last_name]
    account.gender = @normalizer.gender params[:gender]
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

  def sign_in
    params[:username] = @normalizer.username(params[:username])
    params[:password] = @normalizer.password(params[:password])
    params[:password] = encrypt_password(params[:password])

    account = Account.where(username: params[:username], password: params[:password]).first

    unless account.nil?
      @response[:error] = 0
      @response[:body] = account
      login(account)
    else
      @response[:error] = 2
    end

    render json: @response
  end
  def sign_out
    if logout == true
      @response[:error] = 0
    end
    render json: @response
  end
  def sign_out
    if logout == true
      @response[:error] = 0
    end
    render json: @response
  end
  def update_email
    if @user_is_auth
      @current_user.email = @normalizer.email params[:email]
      if @current_user.invalid?
        @response[:error] = 3
        @response[:body] = @current_user.errors.messages
      elsif @current_user.valid? && @current_user.save
        @response[:error] = 0
        @response[:body] = @current_user
      end
    end
    render json: @response
  end
  def update_username
    if @user_is_auth
      @current_user.username = @normalizer.username params[:username]
      if @current_user.invalid?
        @response[:error] = 3
        @response[:body] = @current_user.errors.messages
      elsif @current_user.valid? && @current_user.save
        @response[:error] = 0
        @response[:body] = @current_user
      end
    end
    render json: @response
  end
  def update_password
    if @user_is_auth
      @current_user.password = @normalizer.password params[:password]
      if @current_user.invalid?
        @response[:error] = 3
        @response[:body] = @current_user.errors.messages
      elsif @current_user.valid? && @current_user.save
        @response[:error] = 0
        @response[:body] = @current_user
      end
    end
    render json: @response
  end
  def update_language
    if @user_is_auth
      @current_user.language = @normalizer.language params[:language]
      @current_user.valid?
      if @current_user.save
        @response[:error] = 0
        @response[:body] = @current_user
      end
    end
    render json: @response
  end
  def unactive
    if @user_is_auth
      @current_user.is_active = false
      if @current_user.save
        @response[:error] = 0
        @response[:body] = @current_user.is_active
      end
    end
    render json: @response
  end
  def active
    if @user_is_auth
      @current_user.is_active = true
      if @current_user.save
        @response[:error] = 0
        @response[:body] = @current_user.is_active
      end
    end
    render json: @response
  end
  def update
    if @user_is_auth
      @current_user.first_name = @normalizer.first_name params[:first_name]
      @current_user.last_name = @normalizer.last_name params[:last_name]
      @current_user.gender = @normalizer.gender params[:gender]
      @current_user.birthday = params[:birthday]
      if @current_user.invalid?
        @response[:error] = 3
        @response[:body] = @current_user.errors.messages
      elsif @current_user.valid? && @current_user.save
        @response[:error] = 0
        @response[:body] = @current_user
      end
    end
    render json: @response
  end
end
