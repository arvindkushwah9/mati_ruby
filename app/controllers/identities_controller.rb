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
    @country = ["AD","AE","AF","AG","AI","AL","AM","AO","AR","AT","AU","AW","AZ","BA","BB","BD","BE","BF","BG","BH","BI","BJ","BM","BN","BO","BR","BS","BT","BW","BZ","CA","CD","CF","CG","CH","CI","CL","CM","CN","CO","CR","CW","CY","CZ","DE","DJ","DK","DM","DO","DZ","EC","EE","EG","ER","ES","ET","FI","FJ","FR","GA","GB","GD","GE","GH","GM","GN","GQ","GR","GT","GW","GY","HK","HN","HR","HT","HU","ID","IE","IL","IN","IS","IT","JM","JO","JP","KE","KG","KH","KI","KM","KN","KR","KV","KW","KZ","LA","LB","LC","LI","LK","LS","LT","LU","LV","LY","MA","MC","MD","ME","MG","MK","ML","MM","MN","MT","MU","MV","MW","MX","MY","MZ","NA","NE","NG","NI","NL","NO","NP","NR","NU","NZ","OM","PA","PE","PG","PH","PK","PL","PS","PT","PY","QA","RO","RS","RU","RW","SA","SB","SC","SE","SG","SI","SK","SL","SM","SN","SO","SR","SS","ST","SV","SZ","TD","TG","TH","TJ","TL","TM","TN","TO","TP","TR","TT","TV","TZ","UA","UG","US","UY","UZ","VA","VE","VN","VU","WS","YE","ZA","ZM"]
    @regoin = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NJ","NM","NY","NC","NH","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
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
