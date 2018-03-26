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

# bytes_matrix.each do |chunk|
#   puts "#{chunk.length} - #{chunk}"
# end
# puts "\n\n---------------------------------\n\n"

full_key = []
bytes_matrix.transpose.each do |chunk|
  puts chunk.to_s
  cipher_text_chunk = CipherString.new(chunk.map{ |character| character.chr }.join(''))

  scorer = ASCIIFrequency.new()
  plain_texts = []
  # Limiting to printable characters.
  (32..126).each do |key|
    plain_text = cipher_text_chunk.xor_ascii(key.chr)
    plain_texts.push({
      # transposed_cipher_text: cipher_text_chunk,
      key: key,
      plain_text: plain_text,
      score: scorer.exp_error(plain_text, 5)
    })
  end

  # puts "----------\n#{chunk}\n-----\n"
  # plain_texts.sort_by{ |pt| pt[:score] }.each do |pt|
  plain_texts.sort_by{ |pt| pt[:score] }[0..0].each do |pt|
    # puts "#{pt[:plain_text].bytes}"
    # puts "[#{pt[:key]}] >> #{pt[:key].chr} - #{pt[:score]}\n"
    full_key.push(pt[:key].chr)
  end
  # puts "----------\n\n"
end

# puts "\nFull Key: #{full_key.join('')}\n\n"
# Terminator X: Bring the noise
# puts "#{cipher_text.xor_ascii(full_key.join(''))}"
# puts "#{cipher_text.xor_ascii("Terminator X: Bring the noise")}"
