$accountHelperConfig = AccountHelper::Configuration.new

class AccountValidator < ActiveModel::Validator
  def validate(record)
    # Birthday.
    begin
      year = record.birthday.year
      if year > $accountHelperConfig.year[:max] || year < $accountHelperConfig.year[:min]
        # Is year limit.
          record.errors[:birthday] << "limit"
      end
    rescue
      # Is not correct date.
      record.errors[:birthday] << "invalid"
    end

    # Password.
    if record.password.ascii_only? == false
      record.errors[:password] << "invalid"
    end

    # Inviter.
    if record.inviter.nil?
      record.inviter = nil
    else
      begin
        user = Account.select(:id).where("username = ? OR id = ?", record.inviter, record.inviter.to_i).first
        if user.nil?
          record.errors[:inviter] << "not_found"
        else
          record.inviter = user.id
        end
      rescue
      end
    end
  end
end

class Account < ApplicationRecord
  include AccountHelper
  include ActiveModel::Validations
  validates_with AccountValidator
  before_save do
    self.password = encrypt_password(self.password)
    self.join_time = $time
    self.login_time = $time
  end

  self.per_page = 100

  has_many :my_dialogs, class_name: "Dialog", foreign_key: "account_id", dependent: :destroy
  has_many :dialogs, class_name: "UserDialog", foreign_key: "account_id", dependent: :destroy
  has_many :blacklist, class_name: "Blacklist", foreign_key: "account_id", dependent: :destroy

  attr_accessor :inviter

  validates :username,
      length: { minimum: 5, maximum: 36, too_short: "min", too_long: "max" },
      format: { with: $accountHelperConfig.format[:username], message: "invalid" },
      uniqueness: { message: 'unique' }
  validates :first_name,
      length: { minimum: 1, maximum: 15, too_short: "min", too_long: "max" }
  validates :last_name,
      length: { minimum: 1, maximum: 15, too_short: "min", too_long: "max" }
  validates :email,
      length: { minimum: 5, maximum: 50, too_short: "min", too_long: "max" },
      format: { with: $accountHelperConfig.format[:email], message: "invalid" },
      uniqueness: { message: 'unique' },
      allow_nil: true,
      allow_blank: true
  validates :gender,
      inclusion: { in: [0, 1], message: "invalid" }
  validates :password,
      length: { minimum: 6, maximum: 100, too_short: "min", too_long: "max" }
end
