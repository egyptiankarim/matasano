require_relative "../lib/base64"

class Base64String
  attr_accessor :input_string

  def initialize(input_string)
    @input_string = input_string
  end

  def to_bits()
    rev_lookup = Base64.new().lookup.invert
    base64_bin = []

    @input_string.chars.each do |character|
      unless rev_lookup[character].nil?
        # puts "#{character} - #{rev_lookup[character]} - %06b" % rev_lookup[character]
        base64_bin.push("%06b" % rev_lookup[character])
      end
    end

    return base64_bin.join('')
  end

  def to_ascii(bit_length = 8)
    ascii_bin_strings = self.to_bits.scan(/.{#{bit_length}}/)
    ascii_cipher_text = []
    ascii_bin_strings.each do |character|
      # puts "#{character} - #{character.to_i(2).chr}"
      ascii_cipher_text.push(character.to_i(2).chr)
    end

    return ascii_cipher_text.join('')
  end
end
