class Base

  def initialize(host)
     @host = host
  end

  private

  def local_cert
    :this_channel_is_insecure
  end

  def config
    { timeout: 20 }
  end

  def channel_credentials
  
  end

  def channel_certs
    
  end
end
