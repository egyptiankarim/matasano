#! /usr/local/bin/ruby

# Break repeating-key XOR
# https://cryptopals.com/sets/1/challenges/6

require_relative "../lib/cipher_string"

a = CipherString.new("this is a test")
puts "\"this is a test\" ^ \"wokka wokka!!!\" = #{a.hamming_distance('wokka wokka!!!')}"
