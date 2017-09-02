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
        else
          if dialog.destroy
            @response[:error] = 0
          end
        end
      end
    end
    render json: @response
  end
  def my_dialogs
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialogs = @current_user.my_dialogs.order(time: :desc, id: :desc)
        unless dialogs.length == 0
          @response[:error] = 0
          @response[:body] = dialogs
        end
      end
    end
    render json: @response
  end
  def dialogs
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialogs_ = @current_user.dialogs.all
        ids = Array.new
        new_messages_count = Array.new
        dialogs_.each do |dialog|
          ids.push dialog.id
          item = {
            :id => dialog.id,
            :new_messages_count => dialog.new_messages_count
          }
          new_messages_count.push item
        end

        unless ids.length == 0
          dialogs = Dialog.where(id: ids).order(time: :desc, id: :desc)
          unless dialogs.length == 0
            d = Array.new
            dialogs.each do |dialog|
              dialog = dialog.serializable_hash
              new_messages_count.each do |item|
                if item[:id] == dialog['id']
                  dialog['new_messages_count'] = item[:new_messages_count]
                end
              end
              d.push dialog
            end
            @response[:error] = 0
            @response[:body] = d
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
            end
          end
        else
          @response[:error] = 4
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
          end
        else
          # Dialog is not found.
          @response[:error] = 4
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
          end
        else
          # Dialog is not found.
          @response[:error] = 4
        end
      end
    end
    render json: @response
  end
  def users
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialog_id = params[:dialog_id].to_i
        users_ids = @current_user.dialogs.where(dialog_id: dialog_id).pluck(:account_id)
        unless users_ids.length == 0
          users = Account.where(id: users_ids).order(login_time: :desc, id: :desc)
          unless users.length == 0
            @response[:error] = 0
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
  def dialog
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialog_ = @current_user.dialogs.find(params[:dialog_id].to_i) rescue nil
        unless dialog_.nil?
          dialog = Dialog.find(dialog_.id).serializable_hash
          dialog['new_messages_count'] = dialog_[:new_messages_count]
          @response[:error] = 0
          @response[:body] = dialog
        else
          # Dialog is not found.
          @response[:error] = 4
        end
      end
    end
    render json: @response
  end
  def read
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialog = @current_user.dialogs.find(params[:dialog_id].to_i) rescue nil
        unless dialog.nil?
          dialog.new_messages_count = 0
          if dialog.save(validate: false)
            @response[:error] = 0
          end
        else
          # Dialog is not found.
          @response[:error] = 4
        end
      end
    end
    render json: @response
  end
  def new_message
    if @user_is_auth
      ActiveRecord::Base.transaction do
        text = params[:text].to_s
        dialog = @current_user.dialogs.find(params[:dialog_id].to_i) rescue nil
        unless dialog.nil?
          message = dialog.message.new
          message.text = @dialog_normalizer.message text
          message.account_id = @current_user.id
          if message.invalid?
            @response[:error] = 3
            @response[:body] = message.errors.messages
          else
            if message.save
              dialog_ = Dialog.find(dialog.id) rescue nil
              unless dialog_.nil?
                dialog_.last_message = @dialog_normalizer.last_message text
                dialog_.last_writer_id = @current_user.id
                if dialog_.save
                  dialog.dialog.users.all.each do |dialog|
                    dialog.new_messages_count = dialog.new_messages_count+1
                    unless dialog.save(validate: false)
                      raise ActiveRecord::Rollback
                      @response[:error] = 1
                    else
                      @response[:error] = 0
                    end
                  end
                else
                  raise ActiveRecord::Rollback
                end
              else
                raise ActiveRecord::Rollback
              end
            else
              raise ActiveRecord::Rollback
            end
          end
        else
          # Dialog is not found.
          @response[:error] = 4
        end
      end
    end
    render json: @response
  end
  def messages
    if @user_is_auth
      ActiveRecord::Base.transaction do
        dialog = @current_user.dialogs.find(params[:dialog_id].to_i) rescue nil
        unless dialog.nil?
          @response[:error] = 0
          @response[:body] = dialog.message.all
        else
          # Dialog is not found.
          @response[:error] = 4
        end
      end
    end
    render json: @response
  end
end
