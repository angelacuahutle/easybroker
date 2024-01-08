require 'httparty'

class EasyBrokerAPI
  include HTTParty
  base_uri 'https://api.stagingeb.com/v1'

  def initialize(api_key)
    @options = { headers: { "X-Authorization": api_key } }
  end

  def properties
    handle_response(self.class.get('/properties', @options))
  end

  private

  def handle_response(response)
    case response.code
    when 200
      response.parsed_response['content']
    when 404
      raise 'Not Found: The requested resource could not be found'
    when 500...600
      raise 'Server Error: Something went wrong on the server end'
    else
      raise "Unknown error occurred: #{response.code}"
    end
  end
end
