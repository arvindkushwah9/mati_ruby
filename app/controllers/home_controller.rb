class HomeController < ApplicationController
  require "client.rb"

  def index

  end
  def get_token
    @response = Client.new.get_auth(params)
    session['mati_auth'] =  @response
    session['mati_access_token'] =  @response["access_token"]

    # render json: @response
  end
end
