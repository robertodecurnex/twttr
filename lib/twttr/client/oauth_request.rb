# frozen_string_literal: true

module Twttr
  class Client
    #  OAuth helper methods
    class OAuthRequest
      attr_reader :response

      def initialize(uri, config)
        @uri = uri
        @config = config
        @request = Net::HTTP::Get.new(uri)
        @request['Authorization'] = authorization_header
        @response = nil
      end

      def self.get(uri, config)
        new(uri, config).perform
      end

      def perform
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          # :nocov:
          self.response = http.request request
          # :nocov:
        end

        raise Error::HTTPError, response.message unless response.instance_of?(Net::HTTPOK)

        response
      end

      private

      attr_reader :config, :request, :uri
      attr_writer :response

      def oauth_params
        @oauth_params ||= {
          'oauth_consumer_key' => CGI.escape(config.consumer_key),
          'oauth_nonce' => CGI.escape(SecureRandom.urlsafe_base64(32)),
          'oauth_signature_method' => CGI.escape('HMAC-SHA1'),
          'oauth_timestamp' => CGI.escape(Time.now.to_i.to_s),
          'oauth_token' => CGI.escape(config.access_token),
          'oauth_version' => CGI.escape('1.0')
        }
      end

      def request_params
        @request_params if defined?(@request_params)

        query_params = {}
        uri.query_params.each_pair do |key, value|
          query_params[CGI.escape(key)] = CGI.escape(value)
        end

        @request_params = oauth_params.merge(query_params)
      end

      def authorization_header
        oauth_params['oauth_signature'] = oauth_signature

        serialized_params = oauth_params.keys.sort.map { |k| "#{k}=\"#{oauth_params[k]}\"" }.join(',')

        "OAuth #{serialized_params}"
      end

      def oauth_signature
        signature_params = request_params.keys.sort.map { |k| "#{k}=#{request_params[k]}" }.join('&')

        base_string = "#{request.method}&#{CGI.escape(request.uri.to_s.sub(/\?.*$/,
                                                                           ''))}&#{CGI.escape(signature_params)}"

        auth_code(base_string)
      end

      def auth_code(base_string)
        signin_key = "#{CGI.escape(config.consumer_secret)}&#{CGI.escape(config.access_token_secret)}"

        CGI.escape(Base64.encode64(OpenSSL::HMAC.digest('sha1', signin_key, base_string).to_s).chomp)
      end
    end
  end
end
