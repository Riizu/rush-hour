module RushHour
  class Server < Sinatra::Base
    not_found do
      haml :error
    end

    get '/' do
      haml :index, :layout => false
    end

    post '/find' do
      redirect "/sources/#{params["target"]}"
    end

    post '/sources' do
      client = Client.create({identifier: params["identifier"],root_url: params["rootUrl"]})
      if client.error_messages.include?("can't be blank")
        status 400
        body client.error_messages
      elsif client.error_messages.include?("has already been taken")
        status 403
        body client.error_messages
      else
        status 200
      end
    end

    post '/sources/:identifier/data' do
      parsed_payload = Parser.parse_payload(params["payload"])
      result = DataLoader.load(parsed_payload, params["identifier"])
      status result[:status]
      body result[:body]
    end

    get '/sources/:identifier' do |identifier|
      if Client.find_by(identifier: identifier)
        @client = Client.find_by(identifier: identifier)
        if @client.check_for_payloads
          haml :show, locals: {min: @client.responded_ins.min_response_time,
                               max: @client.responded_ins.max_response_time,
                               average: @client.responded_ins.average_response_time}
        else
          @display_error = "There is currently no payload data for this client."
          haml :error
        end
      else
        @display_error = "This Client Does Not Exist"
        haml :error
      end
    end

    get '/sources/:identifier/urls/:relativepath' do |identifier, path|
      @client = Client.find_by(identifier: identifier)
      name = Url.get_name_by_relative_path(path)
      if @client.urls.find_by(name: name)
        @url = @client.urls.find_by(name: name)
        haml :url, locals: {min: @url.min_response_time,
                            max: @url.max_response_time,
                            average: @url.average_response_time}
      else
        @display_error = "Url not found for given client"
        haml :error
      end
    end


    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      @client = Client.find_by(identifier: identifier)
      if EventName.find_by(name: event_name)
        @event_name = event_name
        @hour_breakdown = @client.breakdown_by_hour(event_name)
        haml :event_name
      else
        @display_error = "Event has not been defined."
        haml :error
      end
    end

  end
end
