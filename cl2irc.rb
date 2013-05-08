require 'rubygems'
require 'bundler/setup'
require 'em-irc'
require 'em-websocket-client'
require 'json'
require 'logger'
require 'cgi'

irc_channel = ENV['IRC_CHANNEL'] || '#ColorlessTest'
cl_channel  = ENV['CL_CHANNEL'] || 'main'

# Hello, this is the IRC client
irc_client = EventMachine::IRC::Client.new do
  host   ENV['IRC_HOST'] || 'irc.rizon.net'
  port   ENV['IRC_PORT'] || '6667'

  on :connect do
    puts 'Connected to IRC'
    user 'server_tan', 0, 'Server-tan'
    nick 'server_tan'
    join irc_channel
  end

  on :disconnect do
    puts 'Disconnected from IRC'
  end

  on :parsed do |hash|
    puts "#{hash[:prefix]} #{hash[:command]} #{hash[:params].join(' ')}"
  end
end

EM.run do
  q = EM::Queue.new

  # This callback on the queue is used to push messages from the WebSocket client to the IRC client
  callback = Proc.new do |line|
    irc_client.message(irc_channel, line)
    q.pop(&callback)
  end

  q.pop(&callback)

  # This is the WebSocket client
  cl_connection = EventMachine::WebSocketClient.connect("ws://chat.thecolorless.net:1234/ws/#{cl_channel}")

  cl_connection.callback do
    puts "Connected to The Colorless Chat"
  end

  cl_connection.errback do |e|
    puts "The Colorless Chat Error: #{e}"
  end

  cl_connection.stream do |msg|
    begin
      parsed_msg     = JSON.parse msg.encode("UTF-8")
      unescaped_text = CGI.unescapeHTML parsed_msg['text']

      q.push("#{parsed_msg['user']['name']}: #{unescaped_text}")
    rescue Exception => e
      puts "The Colorless Chat Exception: #{e}"
    end
  end

  cl_connection.disconnect do
    puts "Disconnected from The Colorless Chat"
    EM::stop_event_loop
  end

  irc_client.connect
end
