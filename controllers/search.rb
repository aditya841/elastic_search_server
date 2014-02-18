class Search

  include EM::Deferrable

  def search(query,domain,id)

    #SEARCH DOMAIN IDENTIFICATION
    if(domain == "all" || domain == "")
      search_domain = ""
    else
      search_domain = domain.to_s + "/"
    end
    
    #SEARCH URL
    server_address = 'http://localhost:9200/'
    search_uri = server_address + id.to_s + '/' + search_domain +'_search'

    puts search_uri
    #REST CALL TO ELASTIC SEARCH
    data = EM::HttpRequest.new(search_uri).post(body: query.to_json)

    #CALLBACK ON RECEIVED DATA
    data.callback do
      data_response = JSON.parse(data.response)
      puts data_response
      send_data = data_response["hits"]
      succeed(send_data.to_json)
    end
    data.errback { fail }
  end
end
