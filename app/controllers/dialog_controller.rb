class DialogController < ApplicationController
  include AccountHelper
  include SessionHelper
  include DialogHelper
  before_action :init_session, :init_account, :init_controller

  def init_controller
    @dialog_normalizer = DialogNormalizer.new
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

  def new_dialog
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialog = @current_user.my_dialogs.new
        dialog.title = @dialog_normalizer.title params[:title]
        dialog.is_anon = @dialog_normalizer.is_anon params[:is_anon]
        dialog.last_writer = @current_user
        if dialog.invalid?
          @response[:error] = 3
          @response[:body] = dialog.errors.messages
        else
          if dialog.save
            users = dialog.users.new
            users.user_id = @current_user.id
            if users.valid? && users.save
              @response[:error] = 0
              @response[:body] = dialog
              @response[:dialogs] = @current_user.dialogs
            else
              raise ActiveRecord::Rollback
            end
          end
        end
      end
    end
    render json: @response
  end
  def delete_dialog
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialog = @current_user.my_dialogs.find(params[:dialog_id]) rescue nil
        if dialog.nil?
          @response[:error] = 4
          @response[:body] = nil
        else
          if dialog.destroy
            @response[:error] = 0
            @response[:body] = nil
          end
        end
      end
    end
    render json: @response
  end
  def my_dialogs
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @response[:error] = 0
        @response[:body] = Array.new
        dialogs = @current_user.my_dialogs.order(time: :desc, id: :desc)
        unless dialogs.length == 0
          @response[:body] = dialogs
        end
      end
    end
    render json: @response
  end
  def dialogs
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @response[:error] = 0
        @response[:body] = Array.new
        dialogs_id = @current_user.dialogs.pluck(:dialog_id)
        unless dialogs_id.length == 0
          dialogs = Dialog.where(id: dialogs_id).order(time: :desc, id: :desc)
          unless dialogs.length == 0
            @response[:body] = dialogs
          end
        end
      end
    end
    render json: @response
  end
  def new_user
    if @user_is_auth
      ActiveRecord::Base.transaction do
        user = @current_user.my_dialogs.find(params[:dialog_id]).users.new rescue nil
        unless user.nil?
          user.user_id = params[:user_id]
          if user.invalid?
            @response[:error] = 3
            @response[:body] = user.errors.messages
          else
            if user.save
              @response[:error] = 0
              @response[:body] = nil
            end
          end
        else
          @response[:error] = 4
          @response[:body] = nil
        end
      end
    end
    render json: @response
  end
  def delete_user
    if @user_is_auth
      ActiveRecord::Base.transaction do
        user_id = params[:user_id].to_i
        user = @current_user.my_dialogs.find(params[:dialog_id]).users.find_by(:account_id => user_id) rescue nil
        unless user.nil?
          if user.destroy
            @response[:error] = 0
            @response[:body] = nil
          end
        else
          # Dialog is not found.
          @response[:error] = 4
          @response[:body] = nil
        end
      end
    end
    render json: @response
  end
  def quit_dialog
    if @user_is_auth
      ActiveRecord::Base.transaction do
        user_id = params[:user_id].to_i
        dialog = @current_user.dialogs.find(params[:dialog_id]) rescue nil
        unless dialog.nil?
          if dialog.destroy
            @response[:error] = 0
            @response[:body] = nil
          end
        else
          # Dialog is not found.
          @response[:error] = 4
          @response[:body] = nil
        end
      end
    end
    render json: @response
  end
  def users
    if @user_is_auth
      ActiveRecord::Base.transaction do
        @response[:error] = 0
        @response[:body] = Array.new
        dialog_id = params[:dialog_id].to_i
        users_ids = @current_user.dialogs.where(dialog_id: dialog_id).pluck(:account_id)
        unless users_ids.length == 0
          users = Account.where(id: users_ids).order(login_time: :desc, id: :desc)
          unless users.length == 0
            @response[:body] = users
          end
        else
          # Dialog is not found.
          @response[:error] = 4
          @response[:body] = nil
        end
      end
    end
    render json: @response
  end
end
