class DialogValidator < ActiveModel::Validator
  def validate(record)
    if $current_user.dialogs.count >= 10
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
    length: { minimum: 1, maximum: 50, too_short: "min", too_long: "max" },
    allow_nil: true
end
