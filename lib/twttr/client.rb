# frozen_string_literal: true

require 'forwardable'
require 'json'
require 'net/http'
require 'oauth'
require 'oauth/request_proxy/net_http'
require 'ostruct'
require 'securerandom'
require 'uri/query_params'

require 'twttr/client/config'
require 'twttr/client/endpoint'
require 'twttr/client/error'
require 'twttr/client/oauth_request'

require 'uri/generic'

module Twttr
  #  Twitter API Client
  class Client
    include Twttr::Client::Endpoint::V2::Users
    include Twttr::Client::Endpoint::V2::Users::Follows

    attr_reader :config

    BASE_URL = 'https://api.twitter.com'

    def initialize
      @config = Config.new
      yield config if block_given?
    end

    def get(path, params: {}, query_params: {})
      uri = uri_for(path, params)
      uri.query = URI.encode_www_form(query_params.compact) unless query_params.compact.empty?

      response = OAuthRequest.get(uri, config)

      JSON.parse(response.body)
    end

    private

    def uri_for(path, params = {})
      return URI.parse("#{BASE_URL}#{path}") if params.empty?

      URI.parse("#{BASE_URL}#{path}" % params) # rubocop:disable Style/FormatString
    end
  end
end
