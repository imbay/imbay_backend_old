$accountHelperConfig = AccountHelper::Configuration.new

class AccountValidator < ActiveModel::Validator
  def validate(record)
    # Birthday.
    begin
      year = record.birthday.year
      if year > $accountHelperConfig.year[:max] || year < $accountHelperConfig.year[:min]
        # Is year limit.
          record.birthday = "1996-11-21"
      end
    rescue
      # Is not correct date.
      record.birthday = "1996-11-21"
    end

    # Password.
    if record.password.ascii_only? == false
      record.errors[:password] << "invalid"
    end

    # Inviter.
    record.inviter = nil
    begin
      user = Account.select('id').where(id: record.inviter).or(username=record.inviter).first
      unless user.nil?
        record.inviter = user.id
      end
    rescue
    end
  end
end

class Account < ApplicationRecord
  include AccountHelper
  include ActiveModel::Validations
  validates_with AccountValidator
  before_save do
    self.password = encrypt_password(self.password)
    self.language = $accountHelperConfig.languages.include?(self.language) ? self.language : $accountHelperConfig.default[:language]
  end

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
end
