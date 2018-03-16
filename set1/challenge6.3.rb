#! /usr/local/bin/ruby

# Break repeating-key XOR
# https://cryptopals.com/sets/1/challenges/6

require_relative "../lib/cipher_string"
require_relative "../lib/ascii_frequency"

input_file = File.open('challenge6_input_ascii.txt', 'r')

cipher_text = CipherString.new(input_file.read)

# Likely key size is 29 bytes.
cipher_text_slices = cipher_text.input_string.scan(/.{29}/)

bytes_matrix = cipher_text_slices.map{ |slice| slice.bytes }

bytes_matrix.transpose.each do |chunk|
  cipher_text_chunk = CipherString.new(chunk.map{ |character| character.chr }.join(''))

  scorer = ASCIIFrequency.new()
  plain_texts = []
  # Limiting to printable characters.
  (32..126).to_a.each do |key|
    text = cipher_text_chunk.xor_ascii(key.chr)

    plain_texts.push({
      key: key,
      text: text,
      score: scorer.exp_error(text, 10)
    })
  end

  plain_texts.each do |pt|
    puts "[#{pt[:key]}] #{pt[:key].chr} - #{pt[:score]}"
  end
end
