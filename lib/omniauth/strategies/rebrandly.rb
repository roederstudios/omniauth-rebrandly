require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Rebrandly
      include OmniAuth::Strategy

      args [:client_id]
      option :name, "rebrandly"
      option :client_options, :site => "http://api.rebrandly.com",
                              :authorize_url => "https://oauth.rebrandly.com/connect/authorize"

      info do
        expires_in = request.params["expires_in"]
        {
          "access_token" => request.params["access_token"],
          "expires_in" =>  expires_in ? expires_in.to_i : nil
        }
      end

      def client
        ::OAuth2::Client.new(options.client_id, nil, deep_symbolize(options.client_options))
      end

      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def authorize_params
        {
          :client_id      => options["client_id"],
          :response_type  => "token",
          :scope          => "rbapi",
          :response_mode  => "form_post",
        }
      end

      protected

      def deep_symbolize(options)
        hash = {}
        options.each do |key, value|
          hash[key.to_sym] = value.is_a?(Hash) ? deep_symbolize(value) : value
        end
        hash
      end
    end
  end
end
