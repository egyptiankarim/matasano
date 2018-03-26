#! /usr/local/bin/ruby

# Break repeating-key XOR
# https://cryptopals.com/sets/1/challenges/6

require_relative "../lib/cipher_string"
require_relative "../lib/b64_string"

input_file_name = ARGV[0] || 'challenge6_input.txt'
input_file = File.open(input_file_name, 'r')

input_text = Base64String.new(input_file.read)

cipher_text = CipherString.new(input_text.to_ascii(8))
File.open('challenge6_input_ascii.txt', 'w').write(cipher_text.input_string)

candidates = {}
(2..40).each do |key_size|
  # puts "Working on key_size #{key_size}..."
  candidates[key_size] = cipher_text.normalized_hamming_distance(key_size, 1000)
end

puts "\nCandidates x Hamming Distance\n\n"
candidates.sort_by{ |key, val| val }.each do |candidate|
  puts "#{candidate}"
end
