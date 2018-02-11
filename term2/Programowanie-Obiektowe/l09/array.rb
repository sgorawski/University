class Array
  def to_pbm
    res = ''
    ctr = 0
    self.each do |row|
      row.each do |pixel|
        if pixel
          res += "1 "
        else
          res += "0 "
        end
        ctr += 1
        if ctr == 35
          res += "\n"
          ctr = 0
        end
      end
    end
    res
  end
end