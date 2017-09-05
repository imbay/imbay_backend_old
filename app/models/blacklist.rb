class BlacklistValidator < ActiveModel::Validator
  def validate(record)
    id = record.user_id
    if Account.exists?(id)
      if id == $current_user.id
        record.errors[:user] << "self"
      else
        if $current_user.blacklist.exists?(user_id: id)
          record.errors[:user] << "is_exists"
        else
          if $current_user.blacklist.limit(Blacklist.limit).count(:id) >= Blacklist.limit
            record.errors[:user] << "limit"
          else
            record.user = Account.select(:id).find(id)
          end
        end
      end
    else
      record.errors[:user] << "not_found"
    end
  end
end

class Blacklist < ApplicationRecord
  include ActiveModel::Validations
  validates_with BlacklistValidator

  before_save do
    self.time = $time
  end

  class << self; attr_accessor :limit end
  @limit = 1000

  attr_accessor :user_id
  self.per_page = 100

  belongs_to :account, class_name: "Account", foreign_key: "account_id"
  belongs_to :user, class_name: "Account", foreign_key: "user_id"
end
