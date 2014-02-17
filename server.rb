require 'eventmachine'
require 'em-http'
require 'em-websocket'
require 'json'
require 'redis'
require 'redis-namespace'
require './config/redis'
require './controllers/token_verify'
require './controllers/doctor_search'

EM.run do
  puts "ELASTIC SEARCH SERVER ON EVENT MACHINE"
  puts "Server started on 0.0.0.0:8080"
  EM::WebSocket.start(host: '0.0.0.0',port: 8080) do |websocket|
    websocket.onopen{ puts "Client Connected" }

    websocket.onmessage do |msg|
      msg = JSON.parse(msg)
      token = msg["token"]
      id = msg["identifier"]
      token_verify = TokenVerify.new
      token_verify.verify(token, id)
      token_verify.callback do |status|
        if (id == "doctor")
          ds = DoctorSearch.new
          ds.search(msg["query"])
          ds.callback do |send_data|
            websocket.send(send_data)
          end
          ds.errback do
            websocket.send("Invalid Query")
          end
        elsif (id == "patient")
          ps = PatientSearch.new
          ps.search(msg["query"])
          ps.callback do |send_data|
            websocket.send(send_data)
          end
          ps.errback do
            websocket.send("Invalid Query")
          end
        else
          ws.send("Invalid identifier")
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
