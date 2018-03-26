#! /usr/local/bin/ruby

# Convert hex to base64
# https://cryptopals.com/sets/1/challenges/1

require_relative "../lib/hex_string"
require_relative "../lib/base64"

input_string = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"

hex = HexString.new(input_string)
b64 = Base64.new()

# We need six bits for a Base64 encoded character.
six_bit_slices = hex.to_binary_slices(6)

base64_chars = []

six_bit_slices.each do |slice|
  base64_chars.push(b64.lookup[slice.to_i(2)])
end

puts base64_chars.join('')
