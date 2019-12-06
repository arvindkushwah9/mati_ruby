# Client for mati connection
class Client

  def test_call
    mati_conn.test_call(test_call_message)
  end

  def get_auth(params)
    require 'net/http'
    require 'net/https'
    uri = URI.parse("https://api.getmati.com/oauth")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    client_id = params[:client_id]
    client_secret = params[:client_secret]
    header_string = Base64.encode64(("#{client_id}:#{client_secret}")).squish.gsub(" ", "")
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
    id = params[:identity][:user_id]
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

  def send_input(params, identity, access_token)
    require 'rest-client'
    

    if params[:input_type] == "document-photo"
      if params[:type].present? && (params[:type] == "driving_license" || params[:type] == "passport")
        path = params[:fron_file].path
        path2 = params[:back_file].path
        response = RestClient.post("https://api.getmati.com/v2/identities/#{identity.identity_id}/send-input", {:inputs => [{"inputType": "document-photo","group": 0,"data": {"type": "national-id","country": params[:country],"region": params[:state],"page": "front","filename": File.basename(path)}}].to_json, :document => File.new(path, 'rb')}, headers={"Authorization": "Bearer #{access_token}"})
        response2 = RestClient.post("https://api.getmati.com/v2/identities/#{identity.identity_id}/send-input", {:inputs => [{"inputType": "document-photo","group": 0,"data": {"type": "national-id","country": params[:country],"region": params[:state],"page": "back","filename": File.basename(path2)}}].to_json, :document => File.new(path2, 'rb')}, headers={"Authorization": "Bearer #{access_token}"})
      else
        path = params[:fron_file].path
        response = RestClient.post("https://api.getmati.com/v2/identities/#{identity.identity_id}/send-input", {:inputs => [{"inputType": "document-photo","group": 0,"data": {"type": "national-id","country": params[:country],"region": params[:state],"page": "front","filename": File.basename(path)}}].to_json, :document => File.new(path, 'rb')}, headers={"Authorization": "Bearer #{access_token}"})
      end
    elsif params[:input_type] == "selfie-photo"
      path = params[:photo].path
      response = RestClient.post("https://api.getmati.com/v2/identities/#{identity.identity_id}/send-input", {:inputs => [{"inputType": "selfie-photo","data": {"filename": File.basename(path)}}].to_json, :document => File.new(path, 'rb')}, headers={"Authorization": "Bearer #{access_token}"})
    elsif params[:input_type] == "selfie-video"
      path = params[:video].path
      response = RestClient.post("https://api.getmati.com/v2/identities/#{identity.identity_id}/send-input", {:inputs => [{"inputType": "selfie-video","data": {"filename": File.basename(path)}}].to_json, :document => File.new(path, 'rb')}, headers={"Authorization": "Bearer #{access_token}"})
    end

    response

  end



  private

  def convert_to_hash(params)
    params.to_h
  end


  def mati_conn
    Mati.new(@host, channel_credentials, config)
  end
end
