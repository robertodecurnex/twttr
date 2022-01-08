# frozen_string_literal: true

require './test/test_helper'

module Twttr
  class Client
    class TestUser < Minitest::Test
      def setup
        @client = Twttr::Client.new do |config|
          config.consumer_key        = 'consumer_key'
          config.consumer_secret     = 'consumer_secret'

          config.access_token        = 'access_token'
          config.access_token_secret = 'access_secret'
        end

        @user = Twttr::Model::User.new({ id: 'user_id' }, @client)
        mock_body = '{
          "data": [
            {"id": "1234", "username": "@username"},
            {"id": "12345", "username": "@username2"}
          ],
          "meta": {"result_count": 2}
        }'
        @mock_oauth_response = OpenStruct.new(body: mock_body)
      end

      def test_initialize
        attrs = {
          created_at: '1640091509',
          description: 'Description',
          entities: [],
          id: 'user_id',
          location: {},
          name: 'Name',
          pinned_tweet_id: 'tweet_id',
          profile_image_url: 'https://twitter.com/image.png',
          protected: true,
          public_metrics: {},
          url: 'https://twitter.com/user_id',
          username: 'Username',
          verified: true,
          withheld: true
        }
        user = Twttr::Model::User.new(attrs)

        attrs.each_key do |key|
          if attrs[key].instance_of?(Hash)
            assert_instance_of(OpenStruct, user.send(key))
            next
          end

          assert_equal(attrs[key], user.send(key))
        end
      end

      def test_following
        mock = lambda do |uri, _config|
          assert_equal('https://api.twitter.com/2/users/user_id/following', uri.to_s)
          @mock_oauth_response
        end
        Twttr::Client::OAuthRequest.stub :get, mock do
          users, token = @user.following
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
          @user.following do |users, token|
            assert_equal(2, users.length)
            users.each { |user| assert_instance_of(Twttr::Model::User, user) }
            assert_nil(nil, token)
          end
        end
      end
    end
  end
end
