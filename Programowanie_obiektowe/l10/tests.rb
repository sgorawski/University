require_relative 'sorted_collection'
require_relative 'search'

test_col = SortedCollection.new
[1, 4, 8, 2, 3, 10, 4, 5].each { |x| test_col.put(x) }
p test_col.to_a

puts test_col.length
puts Search.bin_search(8, test_col)
puts Search.interpolation_search(3, test_col)
