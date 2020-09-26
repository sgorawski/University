class Integer
  def factors
    (1..self).select{|x| self % x == 0}
  end

  def ack(y)
    return y + 1 if self == 0
    return (self - 1).ack(1)  if y == 0
    (self - 1).ack(self.ack(y - 1))
  end

  def perfect
    self.factors[0..-2].sum == self
  end

  def verbally
    digits = [
      'zero', 'one', 'two', 'three', 'four', 'five',
      'six', 'seven', 'eight', 'nine'
    ]
    self.digits.reverse.collect{|x| digits[x]}.join(' ')
  end
end
