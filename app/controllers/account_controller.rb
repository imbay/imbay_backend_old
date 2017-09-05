class AccountController < ApplicationController
  include SessionHelper
  include AccountHelper
  before_action :init_session, :init_account, :init_controller

  def init_controller
    @normalizer = Normalizer.new
    @response = {
      :error => 1,
      :body => nil,
      :session_key => @session_key,
      :is_auth => @user_is_auth
    }
    if @current_user.nil?
      @response[:error] = 2
    end
  end

  def user
    render json: {
      :session_key => @session_key,
      :user => @current_user,
      :is_auth => @user_is_auth
    }
  end

  def sign_up
    ActiveRecord::Base.transaction do
      account = Account.new

      account.username = @normalizer.username params[:username]
      account.password = @normalizer.password params[:password]
      account.language = @normalizer.language params[:language]
      account.inviter = @normalizer.inviter params[:inviter]
      account.email = @normalizer.email params[:email]

      account.first_name = @normalizer.first_name params[:first_name]
      account.last_name = @normalizer.last_name params[:last_name]
      account.gender = @normalizer.gender params[:gender]
      account.birthday = params[:birthday]

      account.joined_ip = request.remote_addr
      account.logged_ip = request.remote_addr

      if account.invalid?
        @response[:error] = 3
        @response[:body] = account.errors.messages
      elsif account.save(validate: false)
        login(account)
        @response[:error] = 0
        @response[:body] = account
      end
    end
    render json: @response
  end

  def sign_in
    params[:username] = @normalizer.username(params[:username])
    params[:password] = @normalizer.password(params[:password])
    params[:password] = encrypt_password(params[:password])

    account = Account.where(username: params[:username], password: params[:password]).first rescue nil

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
  def update_email
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @current_user.email = @normalizer.email params[:email]
        if @current_user.invalid?
          @response[:error] = 3
          @response[:body] = @current_user.errors.messages
        elsif @current_user.save(validate: false)
          @response[:error] = 0
          @response[:body] = @current_user
        end
      end
    end
    render json: @response
  end
  def update_username
    if @user_is_auth
        ActiveRecord::Base.transaction do
        @current_user.username = @normalizer.username params[:username]
        if @current_user.invalid?
          @response[:error] = 3
          @response[:body] = @current_user.errors.messages
        elsif @current_user.save(validate: false)
          @response[:error] = 0
          @response[:body] = @current_user
        end
      end
    end
    render json: @response
  end
  def update_password
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @current_user.password = @normalizer.password params[:password]
        if @current_user.invalid?
          @response[:error] = 3
          @response[:body] = @current_user.errors.messages
        elsif @current_user.save(validate: false)
          @response[:error] = 0
          @response[:body] = @current_user
        end
      end
    end
    render json: @response
  end
  def update_language
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @current_user.language = @normalizer.language params[:language]
        @current_user.valid?
        if @current_user.save(validate: false)
          @response[:error] = 0
          @response[:body] = @current_user
        end
      end
    end
    render json: @response
  end
  def unactive
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @current_user.is_active = false
        if @current_user.save(validate: false)
          @response[:error] = 0
          @response[:body] = @current_user.is_active
        end
      end
    end
    render json: @response
  end
  def active
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @current_user.is_active = true
        if @current_user.save(validate: false)
          @response[:error] = 0
          @response[:body] = @current_user.is_active
        end
      end
    end
    render json: @response
  end
  def update
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @current_user.first_name = @normalizer.first_name params[:first_name]
        @current_user.last_name = @normalizer.last_name params[:last_name]
        @current_user.gender = @normalizer.gender params[:gender]
        @current_user.birthday = params[:birthday]
        if @current_user.invalid?
          @response[:error] = 3
          @response[:body] = @current_user.errors.messages
        elsif @current_user.save(validate: false)
          @response[:error] = 0
          @response[:body] = @current_user
        end
      end
    end
    render json: @response
  end
  def recovery
    email = @normalizer.email params[:email]
    if email.nil?
      @response[:error] = 2
      @response[:body] = nil
    else
      ActiveRecord::Base.transaction do
        user = Account.find_by(email: email) rescue nil
        if user.nil?
          @response[:error] = 2
          @response[:body] = nil
        else
          new_password = SecureRandom.uuid.to_s.gsub('-', '')[0..9]
          user.password = new_password
          if user.save(validate: false)
            puts "Username: #{user.username}"
            puts "Password: #{new_password}"
            puts "E-mail: #{user.email}"
            @response[:error] = 0
            @response[:body] = {
              :email => user.email,
              :password => user.password
            }
          end
        end
      end
    end
    render json: @response
  end
  def blacklist
    page = params[:page].to_i
    if @user_is_auth
      @response[:error] = 0
      users = @current_user.blacklist.paginate(:page => page).order(id: :desc).all.pluck('user_id')
      users_ = Account.where(id: users).limit(Blacklist.limit).all.select(:id, :username, :first_name, :last_name)
      @response[:body] = users_
    end
    render json: @response
  end
end
