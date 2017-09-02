class Message < ApplicationRecord
  validates :text,
      length: { minimum: 1, maximum: 500, too_short: "min", too_long: "max" },
      allow_nil: false,
      allow_blank: false
end
