class UserDialogValidator < ActiveModel::Validator
  def validate(record)
    user = Account.find(record.user_id) rescue nil
    if user.nil?
      record.errors[:user] << "not_found"
    else
      record.user = user
      if record.class.exists?(account_id: record.user_id) == true
        record.errors[:user] << "is_exists"
      end
      if record.class.count >= 10
        record.errors[:user] << "limit"
      end
    end
  end
end

class UserDialog < ApplicationRecord
  include ActiveModel::Validations
  validates_with UserDialogValidator

  attr_accessor :user_id
  belongs_to :user, class_name: "Account", foreign_key: "account_id"
  belongs_to :dialog

  has_many :message, class_name: "Message", foreign_key: "dialog_id", dependent: :destroy
end
