# This class is necessary, because just using the `bytes` method gives us the ASCII values of the input character strings, when what we actually want are hex encodings.

class HexString
  attr_accessor :input_string, :binary_string

  def initialize(input_string)
    @input_string = input_string
    @binary_string = to_binary_strings(4).join('')
  end

  def to_binary_strings(padding = 4)
    binary_strings = []

    @input_string.chars.each do |character|
      binary_strings.push("%0#{padding}b" % character.to_i(16))
    end

    binary_strings
  end

  def to_binary_slices(slice = 4)
    @binary_string.scan(/.{#{slice}}/)
  end

  def to_ascii(bit_length = 8)
    ascii_bin_strings = self.to_binary_slices(bit_length)
    ascii_cipher_text = []
    ascii_bin_strings.each do |character|
      # puts "#{character} - #{character.to_i(2).chr}"
      ascii_cipher_text.push(character.to_i(2).chr)
    end

    return ascii_cipher_text.join('')
  end

  def xor_ascii(key, byte_size = 8)
    xor_characters = []
    key_bytes = key.bytes

    # Wraps the input key to size with our string.
    wrap = 0
    to_binary_slices(byte_size).each do |slice|

      xor_byte = slice.to_i(2) ^ key_bytes[wrap % key_bytes.size]
      xor_characters.push(xor_byte.chr)

      wrap += 1
    end

    return xor_characters.join('')
  end
end
