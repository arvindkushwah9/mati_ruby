class HomeController < ApplicationController
  require "client.rb"

  def index

  end
  def get_token
    @response = Client.new.get_auth
    session['mati_auth'] =  @response
    render json: @response
  end
end
