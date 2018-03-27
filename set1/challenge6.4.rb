#! /usr/local/bin/ruby

# Break repeating-key XOR
# https://cryptopals.com/sets/1/challenges/6

require_relative "../lib/cipher_string"
require_relative "../lib/ascii_frequency"

input_file_name = ARGV[0] || 'challenge6_input_ascii.txt'
input_file = File.open(input_file_name, 'r')

cipher_text = CipherString.new(input_file.read)

full_key = 'Terminator X: Bring the noise'

plain_text = cipher_text.xor_ascii(full_key)

puts "#{plain_text}"
