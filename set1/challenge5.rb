#! /usr/local/bin/ruby

# Implement repeating-key XOR
# https://cryptopals.com/sets/1/challenges/5

require_relative "../lib/cipher_string"

input_file_name = ARGV[0]
input_file = File.open(input_file_name, "r")

plain_text = CipherString.new(input_file.read)

cipher_text = CipherString.new(plain_text.xor_ascii("ICE"))

puts cipher_text.to_hex()
