require_relative '../easy_broker_api'
require 'httparty'

RSpec.describe EasyBrokerAPI do
  let(:api_key) { 'API_KEY' }
  subject(:api) { EasyBrokerAPI.new(api_key) }

  describe '#properties' do
    context 'when the request is successful' do
      before do
        successful_response = instance_double(HTTParty::Response, code: 200, parsed_response: { 'content' => ['Property 1', 'Property 2'] })
        allow(EasyBrokerAPI).to receive(:get).and_return(successful_response)
      end

      it 'returns the properties' do
        expect(api.properties).to eq(['Property 1', 'Property 2'])
      end
    end

    context 'when the request is not found (404)' do
      before do
        not_found_response = instance_double(HTTParty::Response, code: 404)
        allow(EasyBrokerAPI).to receive(:get).and_return(not_found_response)
      end

      it 'raises a not found error' do
        expect { api.properties }.to raise_error('Not Found: The requested resource could not be found')
      end
    end

    context 'when there is a server error (500 range)' do
      before do
        server_error_response = instance_double(HTTParty::Response, code: 500)
        allow(EasyBrokerAPI).to receive(:get).and_return(server_error_response)
      end

      it 'raises a server error' do
        expect { api.properties }.to raise_error('Server Error: Something went wrong on the server end')
      end
    end

    context 'when an unknown error occurs' do
      before do
        unknown_error_response = instance_double(HTTParty::Response, code: 418)
        allow(EasyBrokerAPI).to receive(:get).and_return(unknown_error_response)
      end

      it 'raises an unknown error' do
        expect { api.properties }.to raise_error('Unknown error occurred: 418')
      end
    end
  end
end
