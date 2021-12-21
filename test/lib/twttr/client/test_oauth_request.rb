# frozen_string_literal: true

require './test/test_helper'

module Twttr
  class Client
    class TestOAuthrequest < Minitest::Test
      def setup
        @config = Twttr::Client::Config.new.tap do |c|
          c.access_token = 'access token'
          c.access_token_secret = 'access token secret'
          c.consumer_key = 'consumer key'
          c.consumer_secret = 'consumer secret'
        end

        @uri = URI.parse('https://twitter.com/2/users?key=value&key2=value2')
      end

      def test_authorization_header
        oauth_request = nil
        SecureRandom.stub :urlsafe_base64, 'oXUy0_U0g-el0ptZcqTeNEDQ12lQPfWeyHggjWgQSG0' do
          Time.stub :now, Time.at(1_640_180_883) do
            oauth_request = Twttr::Client::OAuthRequest.new(@uri, @config)
          end
        end
        expected_auth_header = 'OAuth oauth_consumer_key="consumer+key",oauth_nonce="oXUy0_U0g-el0ptZcqTeNEDQ12lQPfWeyHggjWgQSG0",oauth_signature="PACKA0YQDuVE8CQ3340tt25gS0g%3D",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1640180883",oauth_token="access+token",oauth_version="1.0"'
        assert_equal(expected_auth_header, oauth_request.send(:request)['Authorization'])
      end

      def test_get
        mock = Minitest::Mock.new
        mock.expect(:perform, true)
        Twttr::Client::OAuthRequest.stub :new, mock, [@uri, @config] do
          Twttr::Client::OAuthRequest.get(@uri, @config)
        end
        mock.verify
      end

      def test_perform_success
        oauth_request = Twttr::Client::OAuthRequest.new(@uri, @config)
        response = Net::HTTPOK.new('', '', '')
        start_mock = lambda do |host, port, use_ssl:|
          assert_equal('twitter.com', host)
          assert_equal(443, port)
          assert_equal(true, use_ssl)
          oauth_request.send(:response=, response)
        end

        Net::HTTP.stub :start, start_mock do
          assert_equal(response, oauth_request.perform)
        end
      end

      def test_perform_unauthorized
        oauth_request = Twttr::Client::OAuthRequest.new(@uri, @config)
        response = Net::HTTPUnauthorized.new('Message', '', '')
        start_mock = lambda do |host, port, use_ssl:|
          assert_equal('twitter.com', host)
          assert_equal(443, port)
          assert_equal(true, use_ssl)
          oauth_request.send(:response=, response)
        end

        Net::HTTP.stub :start, start_mock do
          assert_raises(Twttr::Client::Error::HTTPError, 'Message') { oauth_request.perform }
        end
      end
    end
  end
end
