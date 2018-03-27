#! /usr/local/bin/ruby

# Single-byte XOR cipher
# https://cryptopals.com/sets/1/challenges/3

require_relative "../lib/hex_string"
require_relative "../lib/base64"
require_relative "../lib/ascii_frequency"

input_string = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

hex_string = HexString.new(input_string)
plain_texts = []
scorer = ASCIIFrequency.new()

# Limiting to printable characters.
(32..126).each do |key|
  text = hex_string.xor_ascii(key.chr)

  plain_texts.push({
    key: key,
    text: text,
    score: scorer.exp_error(text, 10)
  })
end

plain_texts = plain_texts.sort_by { |plain_text| plain_text[:score] }

puts "Top 10 Candidates\n\n"

(0..80).each do |place|
  puts "#{plain_texts[place][:key].chr} (#{plain_texts[place][:key]}) => #{plain_texts[place][:text]} (#{plain_texts[place][:score]})"
end
