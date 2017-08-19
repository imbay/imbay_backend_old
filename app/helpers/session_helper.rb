module SessionHelper
    def init_redis
      # Check redis is connected?
      if @redis.nil? == true
        # Redis is not connected, then connect to the redis server.
        @redis = Redis.new(:host => $redis[:session][:host], :port => $redis[:session][:port], :password => $redis[:session][:password], :db => "session")
      end
    end

    # Return hash or nil.
    def new_session expire = 1.year
        init_redis
        begin
            name = SecureRandom.uuid.to_s.gsub('-', '')
            if @redis.set(name, Hash.new.to_json, ex: expire) == "OK"
                return name
            end
        rescue
        end
    end
    # Session is exists?
    def session_is_exists? session_key
        init_redis
        begin
            return @redis.get(session_key).nil? == true ? false : true
        rescue
        end
        return false
    end
    # Return hash or nil.
    def delete_session session_key
        init_redis
        begin
            @redis.del(session_key)
            return true
        rescue
        end
        return false
    end
    # Return boolean.
    def set_session_value session_key, key, value, expire = nil
        init_redis
        begin
            session = JSON.parse(@redis.get(session_key))
            if session[key].nil?
                session[key] = Hash.new
            end
            value = session[key]['value'] = value
            unless expire.nil?
                session[key]['expire'] = $time+expire.to_i
            else
                session[key]['expire'] = expire
            end
            @redis.set(session_key, session.to_json)
            return true
        rescue
        end
        return false
    end
    # Return string|integer|float|boolean|hash|array or nil.
    def get_session_value session_key, key
        init_redis
        begin
            session = JSON.parse(@redis.get(session_key))
            if session[key]['expire'].nil?
                return session[key]['value']
            elsif session[key]['expire'] >= $time
                return session[key]['value']
            else
                session.delete(key)
            end
            @redis.set(session_key, session.to_json)
        rescue
        end
    end
    # Return boolean.
    def del_session_value session_key, key
        init_redis
        begin
            session = JSON.parse(@redis.get(session_key))
            session.delete(key)
            @redis.set(session_key, session.to_json)
            return true
        rescue
        end
        return false
    end

    # Controller methods.
    def init_session
        if session_is_exists?(params[:session_key]) == false
            @session_key = new_session
        else
            @session_key = params[:session_key]
        end
    end
    def session key
        get_session_value @session_key, key
    end
end
