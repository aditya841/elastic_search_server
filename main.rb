require 'sinatra'
require 'eventmachine'
require 'thin'
require 'rest-client'
require 'json'
require 'redis'
require 'redis-namespace'
require './controllers/search_server'

# Redis Namespace for doctor and patient
$redis_doctor = Redis::Namespace.new("rxhealth_doctor", :redis => Redis.new)
$redis_patient = Redis::Namespace.new("rxhealth_patient", :redis => Redis.new)

# Instance of Search Server
$search = SearchServer.new

# POST REQUEST for Search
post '/search/doctor' do
  $search.doctor_search(params) # Calling the doctor search
  puts $search.data_doctor
  data = $search.data_doctor
  content_type :json
  data.to_json
end

# post '/search/patient' do
#   params = JSON.parse(params)
#   $search.patient_search(params) # Calling the patient search
# end

get '/search' do
  content_type :json
  {email: "piyushchauhan2011"}.to_json
end
