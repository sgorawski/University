require_relative 'open'

class Encrypted
  def initialize(text)
    @text = text
  end

  def decrypt(key)
    open = @text.chars.each.collect{|char| key.key(char)}.join
    Open.new(open)
  end

  def to_s
    @text
  end
end
