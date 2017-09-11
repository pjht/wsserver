class WebSocketConnection

  def initialize(socket)
    @socket = socket
  end

  # Recives a frame from the client.
  def recv
    puts @socket.inspect
    fin_and_opcode = @socket.read(1).bytes[0]
    fin = fin_and_opcode & 0b10000000
    opcode = fin_and_opcode & 0b00001111

    case opcode
    when 1,0
      mask_and_length_indicator = @socket.read(1).bytes[0]
      length_indicator = mask_and_length_indicator & 0x7f

      if length_indicator <= 125
        length = length_indicator
      elsif length_indicator == 126
        length = @socket.read(2).unpack("n")[0]
      else
        length = @socket.read(8).unpack("Q>")[0]
      end

      mask = @socket.read(4).bytes

      masked = @socket.read(length).bytes

      i=0
      $data=[]
      masked.each do |byte|
        $data[i]=byte ^ mask[i % 4]
        i+=1
      end
      data=$data
      string=data.pack("c*")

      if not fin
        string += parse_frame(@socket)
      end

      puts "Got frame: #{string}"

      return string
    when 8
      close
      return false
    else
      send("This server ony supports text data and the close frame")
      close
      return false
    end
  end

  def close()
    bytes = [0b10001000,0]
    data = bytes.pack("C*")
    puts data.inspect
    socket << data
    @socket.close
  end

  # Sends a frame to the client.
  def send(string)
    return if string == false

    puts "Sending frame: #{string}"

    bytes = [0b10000001]
    size = string.bytesize

    if size <= 125
      bytes += [size]
    elsif size < 2**16
      bytes += [126] + [size].pack("n").bytes
    else
      bytes += [127] + [size].pack("Q>").bytes
    end

    bytes += string.bytes
    data = bytes.pack("C*")
    @socket << data
  end
end
