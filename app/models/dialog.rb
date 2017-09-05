class DialogValidator < ActiveModel::Validator
  def validate(record)
    limit = 10
    if $current_user.my_dialogs.limit(limit).count(:id) >= limit
      record.errors[:dialog] << "limit"
    end
  end
end

class Dialog < ApplicationRecord
  include ActiveModel::Validations
  validates_with DialogValidator

  before_save do
    self.time = $time
  end

  belongs_to :account, class_name: "Account", foreign_key: "account_id"
  belongs_to :last_writer, class_name: "Account", foreign_key: "last_writer_id"
  has_many :users, class_name: "UserDialog", foreign_key: "dialog_id", dependent: :destroy
  validates :title,
    length: { minimum: 1, maximum: 50, too_short: "min", too_long: "max" }
end
