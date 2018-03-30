#! /usr/local/bin/ruby

# Detect AES in ECB mode
# https://cryptopals.com/sets/1/challenges/8

require_relative "../lib/cipher_string"
require_relative "../lib/ascii_frequency"
require_relative "../lib/hex_string"

require "openssl"

input_file_name = ARGV[0] || 'challenge8_input.txt'
input_file = File.open(input_file_name, 'r')

candidates = []
input_file.readlines.each do |line|
  hex_chunks = line.scan(/.{16}/)

  candidates.push({
    hex_string: line,
    chunks: hex_chunks,
    unique_chunks: hex_chunks.uniq.length
  })
end


puts "\nCandidates x Hamming Distance\n\n"
# candidates.sort_by{ |c| c[:score] }.each do |candidate|
#   puts "#{candidate[:hex_string].input_string[0..10]} - #{candidate[:score]}"
# end
# puts "\n\n"
candidates.sort_by{ |candidate| candidate[:unique_chunks] }[0..10].each do |c|
  puts "Unique Chunks: #{c[:unique_chunks]} / #{c[:chunks].length}"
  puts "#{c[:hex_string]}\n"
end
