#! /usr/local/bin/ruby

# Fixed XOR
# https://cryptopals.com/sets/1/challenges/2

require_relative "../lib/hex_string"
require_relative "../lib/base64"

string_one = "1c0111001f010100061a024b53535009181c"
string_two = "686974207468652062756c6c277320657965"

string_one_hex = HexString.new(string_one)
string_two_hex = HexString.new(string_two)

int_one = string_one_hex.binary_string.to_i(2)
int_two = string_two_hex.binary_string.to_i(2)

int_xor = int_one ^ int_two

puts int_xor.to_s(16)
