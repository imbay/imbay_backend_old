module UserHelper
  def blocked? id
    id = id.to_i
    Blacklist.exists?(account_id: id.to_i, user_id: @current_user.id)
  end
  def black_user? id
    id = id.to_i
    $current_user.blacklist.exists?(user_id: id)
  end
  def active? id
    id = id.to_i
    Account.exists?(id: id, is_active: true)
  end
  def to_russian value
    value = value.to_s
    translator = {
      'Ә' => 'A',
      'І' => 'И',
      'Ң' => 'Н',
      'Ғ' => 'Ғ',
      'Ү' => 'У',
      'Ұ' => 'У',
      'Қ' => 'К',
      'Ө' => 'О',
      'Һ' => 'Х',
    }
    translator_small = {}
    translator.each do |key, value|
      translator_small[key.downcase] = value.downcase
    end

    translator.each do |key, val|
      value = value.gsub(key, val)
    end
    translator_small.each do |key, val|
      value = value.gsub(key, val)
    end

    return value
  end
  def to_english value
    value = value.to_s
    translator = {
      'А' => 'A',
      'Ә' => 'A',
      'Б' => 'B',
      'В' => 'V',
      'Г' => 'G',
      'Ғ' => 'G',
      'Д' => 'D',
      'Е' => 'E',
      'Ё' => 'Yo',
      'Ж' => 'Zh',
      'З' => 'Z',
      'И' => 'I',
      'Й' => 'I',
      'К' => 'K',
      'Қ' => 'K',
      'Л' => 'L',
      'М' => 'M',
      'Н' => 'N',
      'Ң' => 'N',
      'О' => 'O',
      'Ө' => 'O',
      'П' => 'P',
      'Р' => 'R',
      'С' => 'S',
      'Т' => 'T',
      'У' => 'U',
      'Ұ' => 'U',
      'Ф' => 'F',
      'Х' => 'Kh',
      'Һ' => 'Kh',
      'Ц' => 'C',
      'Ч' => 'Ch',
      'Ш' => 'Sh',
      'Щ' => 'Sh',
      'Ъ' => '',
      'Ы' => 'Y',
      'І' => 'I',
      'Ь' => '',
      'Э' => 'E',
      'Ю' => 'Yu',
      'Я' => 'Ya',
    }
    translator_small = {}
    translator.each do |key, value|
      translator_small[key.downcase] = value.downcase
    end

    translator.each do |key, val|
      value = value.gsub(key, val)
    end
    translator_small.each do |key, val|
      value = value.gsub(key, val)
    end

    return value
  end

  def split_name value
    value = value.to_s.strip
    value = value.scan /[^\s]+/
    return value
  end
  def is_id? value
    value = value.to_s.strip
    is_id = Integer(value) rescue nil
    unless is_id.nil?
      return true
    end
    return false
  end
end
