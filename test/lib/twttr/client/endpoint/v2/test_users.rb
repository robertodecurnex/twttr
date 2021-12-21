# frozen_string_literal: true

require './test/test_helper'

module Twttr
  class Client
    module Endpoint
      module V2
        class TestUsers < Minitest::Test
          def setup
            @client = Twttr::Client.new do |config|
              config.consumer_key        = 'consumer_key'
              config.consumer_secret     = 'consumer_secret'

              config.access_token        = 'access_token'
              config.access_token_secret = 'access_secret'
            end

            @user_mock_oauth_response = OpenStruct.new(body: '{"data": {"id": "1234", "username": "@username"}}')
            @users_mock_oauth_response = OpenStruct.new(body: '{"data": [{"id": "1234", "username": "@username"}, {"id": "12345", "username": "@username2"}]}')
          end

          def test_me
            mock = lambda do |uri, _config|
              assert_equal('https://api.twitter.com/2/users/me', uri.to_s)
              @user_mock_oauth_response
            end
            Twttr::Client::OAuthRequest.stub :get, mock do
              user = @client.me
              assert_instance_of(Twttr::Model::User, user)
              assert_equal('1234', user.id)
              assert_equal('@username', user.username)
            end
          end

          def test_user
            mock = lambda do |uri, _config|
              assert_equal('https://api.twitter.com/2/users/user_id', uri.to_s)
              @user_mock_oauth_response
            end
            Twttr::Client::OAuthRequest.stub :get, mock do
              user = @client.user('user_id')
              assert_instance_of(Twttr::Model::User, user)
              assert_equal('1234', user.id)
              assert_equal('@username', user.username)
            end
          end

          def test_user_by_username
            mock = lambda do |uri, _config|
              assert_equal('https://api.twitter.com/2/users/by/username/username_one', uri.to_s)
              @user_mock_oauth_response
            end
            Twttr::Client::OAuthRequest.stub :get, mock do
              user = @client.user_by_username('username_one')
              assert_instance_of(Twttr::Model::User, user)
              assert_equal('1234', user.id)
              assert_equal('@username', user.username)
            end
          end

          def test_users
            mock = lambda do |uri, _config|
              assert_equal('https://api.twitter.com/2/users?ids=user_id%2Cuser_id_2', uri.to_s)
              @users_mock_oauth_response
            end
            Twttr::Client::OAuthRequest.stub :get, mock do
              users = @client.users(%w[user_id user_id_2])
              assert_equal(2, users.length)
              users.each { |user| assert_instance_of(Twttr::Model::User, user) }
              assert_equal('1234', users.first.id)
              assert_equal('@username', users.first.username)
            end
          end
        end
      end
    end
  end
end
