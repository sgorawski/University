require_relative 'encrypted'


class Open
  def initialize(text)
    @text = text
  end

  def encrypt(key)
    encrypted = @text.chars.each.collect{|char| key[char]}.join
    Encrypted.new(encrypted)
  end

  def to_s
    @text
  end
end

