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
        value = value.to_s.strip
        if value == "0"
          return 0
        elsif value == "1"
          return 1
        else
          return ""
        end
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
        value = value.to_s.strip.downcase
        if value == ""
          return nil
        elsif value[0] == '@'
          return value[1..-1]
        else
          return value
        end
    end
  end
  def encrypt_password value
      Digest::SHA256.hexdigest(value.to_s).to_s
  end
  def init_account
    @current_user = nil
    @user_is_auth = false
    begin
      @current_user = Account.find(session('account_id')) rescue nil
      unless @current_user.nil?
        @user_is_auth = true
      end
    rescue
    end
    $current_user = @current_user
    $user_is_auth = @user_is_auth
  end
  def login account
      begin
        unless account.nil?
            return set_session_value(@session_key, 'account_id', account.id)
        else
            return false
        end
      rescue
      end
      return false
  end
  def logout
      begin
        return del_session_value(@session_key, 'account_id')
      rescue
      end
  end
end
