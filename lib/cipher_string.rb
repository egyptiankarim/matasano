class CipherString
  attr_accessor :input_string, :binary_string

  def initialize(input_string)
    @input_string = input_string
    @binary_string = to_binary_strings(8).join('')
  end

  def to_byte_slices(key_size)
    @input_string.bytes
  end

  def to_binary_strings(padding = 8)
    binary_strings = []

    @input_string.bytes.each do |byte|
      binary_strings.push("%0#{padding}b" % byte)
    end

    binary_strings
  end

  def to_binary_slices(slice = 8)
    @binary_string.scan(/.{#{slice}}/)
  end

  def to_hex()
    hex = []

    to_binary_slices(4).each do |slice|
      hex.push(slice.to_i(2).to_s(16))
    end

    hex.join('')
  end

  def xor_ascii(key, byte_size = 8)
    xor_characters = []
    key_bytes = key.bytes

    # Wraps the input key to size with our string.
    wrap = 0
    @input_string.bytes.each do |byte|

      xor_byte = byte ^ key_bytes[wrap % key_bytes.size]
      xor_characters.push(xor_byte.chr)

      wrap += 1
    end

    return xor_characters.join('')
  end

  def hamming_distance(target_string)
    input_bytes = @input_string.bytes
    target_bytes = target_string.bytes

    frame = [input_bytes.length, target_bytes.length].min

    # 8-bit characters
    hamming_distance = (input_bytes.length - target_bytes.length).abs * 8

    (0...frame).each do |index|
      hamming_distance += (input_bytes[index] ^ target_bytes[index]).to_s(2).count('1')

      # puts "#{input_bytes[index]} ^ #{target_bytes[index]} = #{(input_bytes[index] ^ target_bytes[index]).to_s(2).count('1')}"
      # puts "#{input_bytes[index].to_s(2)} ^ #{target_bytes[index].to_s(2)} = #{(input_bytes[index] ^ target_bytes[index]).to_s(2)}"
    end

    return hamming_distance
  end

  # Use a bootstrap sampling algorithm
  def normalized_hamming_distance(key_size = 8, samples = 1000)
    slices = @input_string.scan(/.{#{key_size}}/)

    # picker = Random.new()
    limiter = slices.length

    # puts "[0]#{slices[0]}, ..., [#{limiter - 1}]#{slices[limiter - 1]}"

    # It's weird to me that this sequential walk through the blocks works better than the bootstrapping method below.
    hamming_sum = 0.0
    (0...(limiter - 1)).each do |sample|
      hamming_sum += CipherString.new(slices[sample]).hamming_distance(slices[sample + 1])
    end

    # # It's weird to me that this bootstrapping method doesn't seem to work.
    # hamming_sum = 0.0
    # (0...samples).each do |sample|
    #   i1 = picker.random_number(limiter)
    #   i2 = picker.random_number(limiter)
    #
    #   pick_one = CipherString.new(slices[i1])
    #   pick_two = slices[i2]
    #
    #   hamming_sum += (pick_one.hamming_distance(pick_two) / key_size)
    #
    #   # puts "[#{i1}]#{pick_one.input_string.bytes} ^ [#{i2}]#{pick_two.bytes} = #{pick_one.hamming_distance(pick_two) / (1.0 * key_size)}"
    # end

    return (hamming_sum / (key_size * limiter))
  end
end
