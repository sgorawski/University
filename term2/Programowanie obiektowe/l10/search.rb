class Search
  def self.bin_search(element, collection, begi = 0, endi = collection.length - 1)
    midi = ((begi + endi) / 2).to_i
    if collection[midi] < element
      return bin_search(element, collection, midi + 1, endi)
    elsif collection[midi] > element
      return bin_search(element, collection, begi, midi - 1)
    end
    midi
  end

  def self.interpolation_search(element, collection, begi = 0, endi = collection.length - 1)
    midi = (begi + ((element - collection[begi]) * (endi - begi) / (collection[endi] - collection[begi]))).to_i
    if collection[midi] < element
      return bin_search(element, collection, midi + 1, endi)
    elsif collection[midi] > element
      return bin_search(element, collection, begi, midi - 1)
    end
    midi
  end
end
