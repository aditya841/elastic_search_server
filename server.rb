#require 'statements'
require 'eventmachine'
require 'em-http'
require 'em-websocket'
require 'json'
require 'redis'
require 'redis-namespace'
require './config/redis'
require './controllers/token_verify'
require './controllers/search'

=begin
  -----------------------Message Structure to be passed -----------------------
  msg["token"] = token
  msg["index"] = doctors/patients/appointment
  msg["domain"] = domain of patient or doctor to be searched [doctor/patient]
  msg["query"] = Search query
=end

EM.run do
  puts "ELASTIC SEARCH SERVER ON EVENT MACHINE"
  puts "Server started on 0.0.0.0:8080"
  EM::WebSocket.start(host: '0.0.0.0',port: 8080) do |websocket|
    websocket.onopen{ puts "Client Connected" }

    websocket.onmessage do |msg|

      msg = JSON.parse(msg)
      token = msg["token"]
      index = msg["index"]
      domain = msg["domain"]
      query = msg["query"]

      token_verify = TokenVerify.new

      token_verify.verify(token, index)

      token_verify.callback do |status|
        if (index == "doctors" || index == "patients")
          ds = Search.new
          ds.search(query,domain,index)
          ds.callback do |send_data|
            websocket.send(send_data)
          end
          ds.errback do
            websocket.send("Invalid Query")
          end
        else
          ws.send("Invalid index")
        end
      end

      token_verify.errback do |status|
        websocket.send("Unauthorized token")
      end

    end
    websocket.onclose { puts "closed" }
    websocket.onerror{ |e| puts "err #{e.inspect}"}
  end
end
