class SearchServer

  attr_accessor :data_doctor

  def doctor_search(params)

    flag_u = false
    flag_s = false
    @data_doctor = ""

    sent_query = params[:sent_query]
    puts sent_query
     # p = {
     #    query: {
     #       query_string: {
     #          query: "piyushchauhan2011%40gmail.com"
     #       }
     #    }
     # }
    EM.run do

      @send_data = EM.spawn do |user, search|
        if (user && search)
          return @data_doctor
        else
          return {error: "Unauthorized user!"}
        end
      end

      EM.defer do
        @data_doctor = RestClient.post 'http://localhost:9200/doctors/doctor/_search', sent_query.to_json
        #puts @data_doctor
        flag_s = true
        @send_data.notify(flag_u, flag_s)
      end

      EM.defer do
        token = params[:token]
        # puts $redis_doctor.get(token)
        flag_u = $redis_doctor.exists(token)
        @send_data.notify(flag_u, flag_s)
      end

    end

    puts 'This method has ended'
  end

  def patient_search(params)

    flag_u = false
    flag_s = false



  end
end
