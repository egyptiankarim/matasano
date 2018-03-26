#! /usr/local/bin/ruby

# Detect single-character XOR
# https://cryptopals.com/sets/1/challenges/4

require_relative "../lib/hex_string"
require_relative "../lib/base64"
require_relative "../lib/ascii_frequency"

input_file_name = ARGV[0] || 'challenge4_input.txt'
input_file = File.open(input_file_name, "r")

plain_texts = []
scorer = ASCIIFrequency.new()

input_file.readlines.each do |line|
  hex_string = HexString.new(line)

  # Limiting to printable characters.
  (32..126).each do |key|
    text = hex_string.xor_ascii(key.chr)

    plain_texts.push({
      hex: line,
      key: key,
      text: text,
      score: scorer.exp_error(text, 10)
    })
  end
end

input_file.close

plain_texts = plain_texts.sort_by { |plain_text| plain_text[:score] }

puts "Top 10 Candidates\n\n"

(0..10).each do |place|
  puts "#{plain_texts[place][:hex]} x #{plain_texts[place][:key].chr} (#{plain_texts[place][:key]}) => #{plain_texts[place][:text]} (#{plain_texts[place][:score]})"
end
