VERSION="1.0"
Gem::Specification.new do |spec|
  spec.name = "wsserver"
  spec.version=VERSION
  spec.authors = ["pjht"]
  spec.summary = "This gem is a WebSocket server for Ruby"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = ["lib/wsserver.rb","lib/wsserver/websocket_connection.rb","lib/wsserver/websocket_server.rb"]
end
