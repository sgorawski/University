require_relative 'integer'
require_relative 'open'


# ZADANIE 1
# factors tests
p 6.factors

# ack tests
puts 2.ack(1)

# perfect tests
puts 5.perfect
puts 6.perfect

# verbally tests
puts 123.verbally

# ZADANIE 3
alphabet = 'abcdefghijklmnopqrstuvwxyz'.chars
code = alphabet.shuffle
key = Hash[alphabet.zip(code)]

open = Open.new('testword')
puts key
puts open.encrypt(key).to_s
puts open.encrypt(key).decrypt(key).to_s
