#! /usr/local/bin/ruby

# Break repeating-key XOR
# https://cryptopals.com/sets/1/challenges/6

require_relative "../lib/cipher_string"
require_relative "../lib/ascii_frequency"

input_file_name = ARGV[0] || 'challenge6_input_ascii.txt'
input_file = File.open(input_file_name, 'r')

cipher_text = CipherString.new(input_file.read)

# puts "#{cipher_text.input_string.bytes}"
# puts "\n\n---------------------------------\n\n"

# Likely key size is 29 bytes.
cipher_text_slices = cipher_text.input_string.scan(/.{29}/)
bytes_matrix = cipher_text_slices.map{ |slice| slice.bytes }

full_key = []
puts bytes_matrix.to_s
puts "\n\n\n"
bytes_matrix.transpose.each do |chunk|
  puts chunk.to_s
  cipher_text_chunk = CipherString.new(chunk.map{ |character| character.chr }.join(''))

  scorer = ASCIIFrequency.new()
  plain_texts = []
  # Limiting to printable characters.
  (32..126).each do |key|
    plain_text = cipher_text_chunk.xor_ascii(key.chr)
    plain_texts.push({
      key: key,
      plain_text: plain_text,
      score: scorer.exp_error(plain_text, 10)
    })
  end

  plain_texts.sort_by{ |pt| pt[:score] }[0].each do |pt|
    # full_key.push(pt[:key].chr)
  end
end

# puts "Key: #{full_key}"
