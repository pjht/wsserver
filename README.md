# wsserver
This gem is a WebSocket server for Ruby.

## Installation
Download the latest release and run `gem install wsserver.gem` in the directory where you put it.

## Usage
Put this code in a file:

```ruby
server = WebsocketServer.new

while true
  Thread.new(server.accept) do |connection|
    # Your code here
  end
end
```
To receive a message from the client do `connection.recv`.
Note: connection.recv will return false if the connection was closed.
To send a message to the client do `connection.send`.
To close the connection do `connection.close`
The WebSocketServer class accepts two named arguments as well:
host: The host this server will run on. Defaults to localhost.
port: The port the server will run on. Defaults to 4567.
