class DoctorSearch

  include EM::Deferrable

  def search(query)
    if(domain == "all" || domain == "")
      search_domain = ""
    else
      search_domain = domain.to_s + "/"
    end
    
    data = EM::HttpRequest.new('http://localhost:9200/doctors/' + search_domain +'_search').post(body: query.to_json)
    data.callback do
      data_response = JSON.parse(data.response)
      puts data_response
      send_data = data_response["hits"]["hits"]
      succeed(send_data.to_json)
    end
    data.errback { fail }
  end

end
