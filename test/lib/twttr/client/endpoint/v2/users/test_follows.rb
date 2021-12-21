# frozen_string_literal: true

require './test/test_helper'

module Twttr
  class Client
    module Endpoint
      module V2
        module Users
          class TestFollows < Minitest::Test
            def setup
              @client = Twttr::Client.new do |config|
                config.consumer_key        = 'consumer_key'
                config.consumer_secret     = 'consumer_secret'

                config.access_token        = 'access_token'
                config.access_token_secret = 'access_secret'
              end

              mock_body = '{
                "data": [
                  {"id": "1234", "username": "@username"},
                  {"id": "12345", "username": "@username2"}
                ],
                "meta": {}
              }'
              @mock_oauth_response = OpenStruct.new(body: mock_body)
            end

            def test_following
              mock = lambda do |uri, _config|
                assert_equal('https://api.twitter.com/2/users/user_id/following', uri.to_s)
                @mock_oauth_response
              end
              Twttr::Client::OAuthRequest.stub :get, mock do
                users, token = @client.following('user_id')
                assert_equal(2, users.length)
                users.each { |user| assert_instance_of(Twttr::Model::User, user) }
                assert_nil(token)
              end
            end

            def test_following_with_block
              mock = lambda do |uri, _config|
                assert_equal('https://api.twitter.com/2/users/user_id/following', uri.to_s)
                @mock_oauth_response
              end
              Twttr::Client::OAuthRequest.stub :get, mock do
                @client.following('user_id') do |users, token|
                  assert_equal(2, users.length)
                  users.each { |user| assert_instance_of(Twttr::Model::User, user) }
                  assert_nil(nil, token)
                end
              end
            end
          end
        end
      end
    end
  end
end
