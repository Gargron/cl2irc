require 'rubygems'
require 'bundler/setup'
require 'em-irc'
require 'em-websocket-client'
require 'json'
require 'logger'
require 'cgi'

irc_client = EventMachine::IRC::Client.new do
  host   'irc.rizon.net'
  port   '6667'

  on :connect do
    nick 'server_tan'
    join "#Colorless"
  end
end

EM.run do
  q = EM::Queue.new

  callback = Proc.new do |line|
    irc_client.message("#Colorless", line)
    q.pop(&callback)
  end

  q.pop(&callback)

  cl_connection = EventMachine::WebSocketClient.connect('ws://chat.thecolorless.net:1234/ws/main')

  cl_connection.callback do
    puts "Connected"
  end

  cl_connection.errback do |e|
    puts "Error: #{e}"
  end

  cl_connection.stream do |msg|
    begin
      parsed_msg = JSON.parse msg.encode("UTF-8")
      q.push("#{parsed_msg['user']['name']}: #{CGI.unescapeHTML(parsed_msg['text'])}")
    rescue Exception => e
      puts "Exception: #{e}"
    end
  end

  cl_connection.disconnect do
    puts "Disconnected"
    EM::stop_event_loop
  end

  irc_client.connect
end
