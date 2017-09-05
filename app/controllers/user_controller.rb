class UserController < ApplicationController
  include SessionHelper
  include AccountHelper
  include UserHelper
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

  def profile
    if @user_is_auth
      ActiveRecord::Base.transaction do
        id = params[:id].to_i
        user = Account.find(id) rescue nil
        unless user.nil?
          @response[:error] = 0
          result = nil
          if user.is_active == false
            result = {
              is_active: user.is_active,
              id: user.id,
              username: user.username,
            }
          elsif user.is_active == true
            if blocked?(id)
              result = {
                blocked: true,
                is_active: user.is_active,
                id: user.id,
                first_name: user.first_name,
                last_name: user.last_name,
                username: user.username,
                gender: user.gender,
              }
            else
              result = {
                blocked: false,
                is_active: user.is_active,
                id: user.id,
                first_name: user.first_name,
                last_name: user.last_name,
                username: user.username,
                birthday: user.birthday,
                gender: user.gender,
                login_time: user.login_time,
                join_time: user.join_time,
              }
            end
          end
          @response[:body] = result
        else
          @response[:error] = 4
        end
      end
    end
    render json: @response
  end
  def search
    if @user_is_auth
      @response[:error] = 0
      input = params[:input].strip
      page = params[:page].to_i
      users = []
      model_ = Account.select(:id, :username, :first_name, :last_name, :first_name_ru, :last_name_ru, :first_name_en, :last_name_en).order(login_time: :desc, id: :desc)
      if input == ""
        users = model_.where(is_active: true).paginate(:page => page).all
      else
        if is_id?(input)
          users = model_.where(is_active: true, id: input).limit(1).all
        else
          split = split_name(input)
          if split.length == 1
            # username or first name or last name
            name = split[0].capitalize
            users = model_.where("is_active = ? AND username = ? OR first_name IN (?) OR last_name IN (?) OR first_name_ru = ? OR last_name_ru = ? OR first_name_en = ? OR last_name_en = ?", true, split[0].downcase, [name, to_russian(name), to_english(name)], [name, to_russian(name), to_english(name)], name, name, name, name).limit(100).all
          elsif split.length == 2
            # first name and last name.
            name = split[0].capitalize
            name1 = split[1].capitalize
            users = model_.where("is_active = ? AND
            (
            (first_name IN (?) AND last_name IN (?)) OR
            (last_name IN (?) AND first_name IN (?)) OR
            (first_name_ru = ? AND last_name_ru = ?) OR
            (last_name_ru = ? AND first_name_ru = ?) OR
            (first_name_en = ? AND last_name_en = ?) OR
            (last_name_en = ? AND first_name_en = ?)
            )
            ", true,
            [name, to_russian(name), to_english(name)], [name1, to_russian(name1), to_english(name1)],
            [name, to_russian(name), to_english(name)], [name1, to_russian(name1), to_english(name1)],
            name, name1,
            name, name1,
            name, name1,
            name, name1).limit(100).all
          end
        end
        @response[:body] = users
      end
    end
    @response[:body] = users
    render json: @response
  end
  def block
    if @user_is_auth
      id = params[:id].to_i
      ActiveRecord::Base.transaction do
        bl = @current_user.blacklist.new
        bl.user_id = id
        if bl.invalid?
          @response[:error] = 3
          @response[:body] = bl.errors.messages
        else
          if bl.save
            @response[:error] = 0
          end
        end
      end
    end
    render json: @response
  end
  def unblock
    if @user_is_auth
      id = params[:id].to_i
      ActiveRecord::Base.transaction do
        user = @current_user.blacklist.find_by(user_id: id) rescue nil
        unless user.nil?
          if user.destroy
            @response[:error] = 0
          end
        else
          @response[:error] = 4
        end
      end
    end
    render json: @response
  end
  def message
    if @user_is_auth
      ActiveRecord::Base.transaction do
      end
    end
    @response[:body] = users
    render json: @response
  end
end
