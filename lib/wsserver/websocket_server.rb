require 'socket'
require 'digest/sha1'
require 'base64'
require_relative "websocket_connection.rb"

class WebSocketServer
  # Initalize a new WebSocketServer.
  def initialize(path: '/', port: 4567, host: 'localhost')
    @path=path
    @tcp_server = TCPServer.new(host, port)
  end

  # Accept a WebSocket connection. Returns a new WebSocketConnection bound to the connection.
  def accept
    socket = @tcp_server.accept
    success=send_handshake(socket)
    return WebSocketConnection.new(socket) if success
  end

  private

  def send_handshake(socket)
    http_request = {}
    while (line = socket.gets) && (line != "\r\n")
      key, value = line.split(": ")
      value=value.chomp if value != nil
      http_request[key] = value
    end

    if http_request.has_key? "Sec-WebSocket-Key"
      websocket_key = http_request["Sec-WebSocket-Key"]
      puts "Websocket handshake detected with key: #{ websocket_key.inspect }"
    else
      puts "Aborting non-websocket connection"
      socket << "HTTP/1.1 400 Bad Request\r\n" +
                "Content-Type: text/plain\r\n" +
                "Connection: close\r\n" +
                "\r\n"
      socket.close
      return false
    end

    response_key = Digest::SHA1.base64digest(websocket_key+"258EAFA5-E914-47DA-95CA-C5AB0DC85B11")
    puts "Responding to handshake with key: #{ response_key }"

    socket << "HTTP/1.1 101 Switching Protocols\r\n" +
              "Upgrade: websocket\r\n" +
              "Connection: Upgrade\r\n"+
              "Sec-WebSocket-Accept: #{ response_key }\r\n" +
              "\r\n"
    return true
  end

end
