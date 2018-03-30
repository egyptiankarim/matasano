#! /usr/local/bin/ruby

# AES in ECB mode
# https://cryptopals.com/sets/1/challenges/7

require_relative "../lib/cipher_string"
require_relative "../lib/b64_string"

require "openssl"

input_file_name = ARGV[0] || 'challenge7_input.txt'
input_file = File.open(input_file_name, 'r')

cipher_text = Base64String.new(input_file.read).to_ascii

cipher = OpenSSL::Cipher.new('aes-128-ecb')
cipher.decrypt
cipher.key = "YELLOW SUBMARINE"

plain_text = cipher.update(cipher_text)

puts plain_text
