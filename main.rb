require_relative 'easy_broker_api'
require 'yaml'

class ConfigLoader
  def self.load(file)
    YAML.load_file(file)
  end
end

# Main execution
if __FILE__ == $0
  config = ConfigLoader.load('config.yml')
  api_key = config['easy_broker']['API_KEY']  # Use the name 'API_KEY' to retrieve the key
  
  api = EasyBrokerAPI.new(api_key)
  
  begin
    properties = api.properties
    properties.each { |property| puts property['title'] }
  rescue => e
    puts e.message
  end
end
