module AccountHelper
  class Configuration
    attr_reader :default, :languages, :format, :year
    def initialize
        @default = {
            :language => 'en'
        }
        @languages = ['kk', 'ru', 'en']
        @format = {
            :username => /
            (?!(^[\d]+$)) # excludes.
            \A(
                (
                    ([a-z\d]+)
                    (
                        ([\._-])?
                        ([a-z\d]+)
                    )+
                )
            )\z
            /x,
            :email => /
            \A(
                ([a-z\d\._-]+)
                @
                ([a-z\d\._-]+)
            )\z
            /x
        }
        @year = {
            :min => 1900,
            :max => 2012
        }
    end
  end
  class Normalizer
    attr_reader :config
    def initialize
        @config = Configuration.new
    end
    def username value
        value.to_s.strip.downcase
    end
    def first_name value
        value.to_s.strip.gsub(' ', '').capitalize
    end
    def last_name value
        self.first_name value
    end
    def gender value
        value = value.to_s.strip.to_i == 1 ? 1 : 0
    end
    def email value
        value = value.to_s.strip.downcase
        if value == ""
            return nil
        else
            return value
        end
    end
    def password value
        value.to_s.strip
    end
    def language value
        value = @config.languages.include?(value) ? value : @config.default[:language]
    end
    def balance value
        value.to_s.strip.gsub(' ', '').to_i
    end
    def inviter value
        value.to_s.strip.gsub(' ', '').to_i
    end
  end
  def encrypt_password value
      Digest::SHA256.hexdigest(value.to_s).to_s
  end
end
