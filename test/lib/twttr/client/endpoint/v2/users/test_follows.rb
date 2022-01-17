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

              first_mock_body = '{
                "data": [
                  {"id": "1234", "username": "@username"},
                  {"id": "12345", "username": "@username2"}
                ],
                "meta": {"result_count": 2, "pagination_token": "next-token"}
              }'
              second_mock_body = '{
                "data": [
                  {"id": "123456", "username": "@username3"},
                  {"id": "1234567", "username": "@username4"}
                ],
                "meta": {"result_count": 2}
              }'
              @mock_oauth_responses = {
                'https://api.twitter.com/2/users/user_id/following' => OpenStruct.new(body: first_mock_body),
                'https://api.twitter.com/2/users/user_id/following?pagination_token=next-token' => OpenStruct.new(body: second_mock_body)
              }
            end

            def test_following
              mock = lambda do |uri, _config|
                @mock_oauth_responses[uri.to_s]
              end
              Twttr::Client::OAuthRequest.stub :get, mock do
                users = @client.following('user_id')
                assert_equal(4, users.length)
                users.each { |user| assert_instance_of(Twttr::Model::User, user) }
              end
            end

            def test_following_with_block
              mock = lambda do |uri, _config|
                @mock_oauth_responses[uri.to_s]
              end
              Twttr::Client::OAuthRequest.stub :get, mock do
                all_users = @client.following('user_id') do |users, token|
                  assert_equal(2, users.length)
                  users.each { |user| assert_instance_of(Twttr::Model::User, user) }
                  assert_nil(nil, token)
                end
                assert_equal(4, all_users.length)
                all_users.each { |user| assert_instance_of(Twttr::Model::User, user) }
              end
            end

            def test_following_without_results
              mock_body = '{
                "data": [],
                "meta": {"result_count": 0}
              }'
              mock = lambda do |uri, _config|
                assert_equal('https://api.twitter.com/2/users/user_id/following', uri.to_s)
                OpenStruct.new(body: mock_body)
              end
              Twttr::Client::OAuthRequest.stub :get, mock do
                response = @client.following('user_id') do |_users, _token|
                  assert(false, 'Block should not be called')
                end

                assert_equal([[], nil], response)
              end
            end
          end
        end
      end
    end
  end
end
