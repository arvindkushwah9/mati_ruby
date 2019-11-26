# Client for mati connection
class Client

  def test_call
    mati_conn.test_call(test_call_message)
  end

  def get_auth
     require 'net/http'
    require 'net/https'
    uri = URI.parse("https://api.getmati.com/oauth")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    client_id = ENV['CLIENT_ID']
    client_secret =  ENV['CLIENT_SECRET']
    header_string =  Base64.encode64(("#{client_id}:#{client_secret}")).squish.gsub(" ", "")
    request.set_form_data('grant_type' => 'client_credentials')
    request.initialize_http_header({"Authorization" => "Basic " + header_string.squish, "Content-Type" => "application/x-www-form-urlencoded"})
    response = http.request(request)
    unless response.is_a?(Net::HTTPSuccess)
      puts 'We currently do not offer account linking with that'
    end
    json = ActiveSupport::JSON.decode(response.body)
  end

  def create_identity(params)
    #params = {"metadata":{"user":"JOHN MALCOVICH","id":"8ad234f293ed89a89d88e12ab"}}
     require 'net/http'
    require 'net/https'
    uri = URI.parse("https://api.getmati.com/v2/identities")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {"Authorization" => "Bearer #{params[:identity][:token]}",'Content-Type' => 'application/json'})

    user = params[:identity][:user_name]
    id = params[:identity][:id]
    # request.set_form_data({"metadata":{"user":"#{user}","id": "#{id}"}})


    request.body = {"metadata":{"user":"#{user}","id": "#{id}"}}.to_json

    response = http.request(request)
    unless response.is_a?(Net::HTTPSuccess)
      puts 'We currently do not offer account linking with that'
      json = {message: "Invalide Token"}
    else
      json = ActiveSupport::JSON.decode(response.body)

    end
  end



  private

  def convert_to_hash(params)
    params.to_h
  end


  def mati_conn
    Mati.new(@host, channel_credentials, config)
  end
end
