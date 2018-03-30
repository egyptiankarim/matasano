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

# Originally was doing this with the `slice` method and a regular expression
# looking for strings of key size length... The regex wasn't matching everything
# it should, and it screwed me up for a long time. Always work with bytes!
# Likely key size is 29 bytes.
bytes_matrix = []
cipher_text_chopped = cipher_text.input_string.bytes
until cipher_text_chopped.length < 29
  bytes_matrix.push(cipher_text_chopped.shift(29))
end

full_key = []
bytes_matrix.transpose.each do |chunk|
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

  plain_texts.sort_by{ |pt| pt[:score] }[0..0].each do |pt|
    puts "#{chunk}"
    puts "#{pt[:key]} [#{pt[:key].chr}]"
    puts "#{pt[:plain_text]}"
    full_key.push(pt[:key].chr)
  end
  puts "\n"
end

puts "\nKey: #{full_key.join('')}"
