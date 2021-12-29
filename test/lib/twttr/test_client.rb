# frozen_string_literal: true

require './test/test_helper'

module Twttr
  class TestsClient < Minitest::Test
    def setup
      @client = Twttr::Client.new do |config|
        config.consumer_key        = 'consumer_key'
        config.consumer_secret     = 'consumer_secret'

        config.access_token        = 'access_token'
        config.access_token_secret = 'access_secret'

        config.user_fields         = %w[id name username]
      end
    end

    def test_initialize
      assert_instance_of(Twttr::Client, Twttr::Client.new)

      Twttr::Client.new do |config|
        assert_instance_of(Client::Config, config)
      end
    end

    def test_config_user_fields
      assert_equal(@client.config.user_fields, 'id,name,username')
    end

    def test_get_without_params
      mock_response = OpenStruct.new(body: '{}')

      mock = lambda do |uri, config|
        assert_equal('https://api.twitter.com/test/path', uri.to_s)
        assert_equal(@client.config, config)
        mock_response
      end
      Twttr::Client::OAuthRequest.stub :get, mock do
        @client.get('/test/path')
      end
    end

    def test_get_with_params
      mock_response = OpenStruct.new(body: '{}')

      mock = lambda do |uri, config|
        assert_equal('https://api.twitter.com/test/path/value', uri.to_s)
        assert_equal(@client.config, config)
        mock_response
      end
      Twttr::Client::OAuthRequest.stub :get, mock do
        @client.get('/test/path/%<key>s', params: { key: 'value' })
      end
    end

    def test_get_with_query_params
      mock_response = OpenStruct.new(body: '{}')

      mock = lambda do |uri, config|
        assert_equal('https://api.twitter.com/test/path?key=value', uri.to_s)
        assert_equal(@client.config, config)
        mock_response
      end
      Twttr::Client::OAuthRequest.stub :get, mock do
        @client.get('/test/path', query_params: { key: 'value' })
      end
    end

    def test_get_response
      mock_response = OpenStruct.new(body: '{"key": {"inner_key": "value"}}')

      Twttr::Client::OAuthRequest.stub :get, mock_response do
        response = @client.get('/test/path', query_params: { key: 'value' })
        assert_equal({ 'key' => { 'inner_key' => 'value' } }, response)
      end
    end
  end
end
