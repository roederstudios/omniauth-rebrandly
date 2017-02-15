require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Rebrandly < OmniAuth::Strategies::OAuth2
      option :name, "rebrandly"
      option :client_options, :site => "http://api.rebrandly.com",
                              :authorize_url => "https://oauth.rebrandly.com/connect/authorize"

      info do
        {
          "login" => "asdf"
        }
      end

      def request_phase
        options[:authorize_params] = {
          :client_id      => options["client_id"],
          :response_type  => "token",
          :scope          => "rbapi",
        }
        super
      end
    end
  end
end
