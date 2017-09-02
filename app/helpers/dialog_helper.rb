module DialogHelper
  class DialogNormalizer
    def title value
      value = value.to_s.strip
      if value == ""
        return nil
      else
        return value
      end
    end
    def is_anon value
      value = value.to_s.strip
      if value == "1"
        return true
      else
        return false
      end
    end
    def message value
      value.to_s.strip
    end
    def last_message value
      value = value.to_s.strip
      if value.length > 17
        value[0..15]+'...'
      else
        value
      end
    end
  end
end
