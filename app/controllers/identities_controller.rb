class IdentitiesController < ApplicationController
  before_action :set_identity, only: [:show, :edit, :update, :destroy]
  require "client.rb"

  # GET /identities
  # GET /identities.json
  def index
    @identities = Identity.all
  end

  # GET /identities/1
  # GET /identities/1.json
  def show
    @response = Client.new.send_input(@identity)
    session['mati_auth'] =  @response
    render json: @response
  end

  # GET /identities/new
  def new
    @identity = Identity.new
  end

  # GET /identities/1/edit
  def edit
  end

  # POST /identities
  # POST /identities.json
  def create
    @identity = Identity.new(identity_params)
    @response = Client.new.create_identity(params)
    session['mati_auth'] =  @response
    @identity.identity_id = @response["_id"]
    @identity.save
    redirect_to "/identities/#{@identity.id}/uploade_data"
    # respond_to do |format|
    #   if @identity.save
    #     format.html { redirect_to @identity, notice: 'Identity was successfully created.' }
    #     format.json { render :show, status: :created, location: @identity }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @identity.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def uploade_data
    @identity = Identity.find(params[:id])
  end

  def country_select
    if params[:country_code] == "US"
      @states = CS.states(params[:country_code])
    else
      @states = {}
    end
    respond_to do |format|
      format.js {  }
    end
  end

  def submit_uploade_data
    @identity = Identity.find(params[:identity_id])
    puts "*********access_token: #{session['mati_access_token']}"
    @response = Client.new.send_input(params, @identity, session['mati_access_token'])
    session['mati_auth'] =  @response
  end

  # PATCH/PUT /identities/1
  # PATCH/PUT /identities/1.json
  def update
    respond_to do |format|
      if @identity.update(identity_params)
        format.html { redirect_to @identity, notice: 'Identity was successfully updated.' }
        format.json { render :show, status: :ok, location: @identity }
      else
        format.html { render :edit }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identities/1
  # DELETE /identities/1.json
  def destroy
    @identity.destroy
    respond_to do |format|
      format.html { redirect_to identities_url, notice: 'Identity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_identity
      @identity = Identity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def identity_params
      params.require(:identity).permit(:user_name, :user_id)
    end
end
