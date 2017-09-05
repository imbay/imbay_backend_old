class MessageValidator < ActiveModel::Validator
  def validate(record)
    limit = 1000
    time = 86400 # one day in seconds.
    count = Message.where("account_id = ? AND time > ?", record.account_id, $time.to_i-time).limit(limit).all.count(:id)
    if count >= limit
      record.errors[:message] << "limit"
    end
  end
end

class Message < ApplicationRecord
  include ActiveModel::Validations
  validates_with MessageValidator

  self.per_page = 100

  validates :text,
      length: { minimum: 1, maximum: 500, too_short: "min", too_long: "max" },
      allow_nil: false,
      allow_blank: false
end
