# frozen_string_literal: true

module Twttr
  module Model
    # Twitter User representation
    # https://developer.twitter.com/en/docs/twitter-api/data-dictionary/object-model/user
    class User
      extend Forwardable

      def_delegators :@data, :created_at, :description, :entities, :id, :location, :name, :pinned_tweet_id,
                     :profile_image_url, :protected, :public_metrics, :url, :username, :verified, :withheld

      def initialize(data, client = nil)
        @data = JSON.parse(data.to_json, object_class: OpenStruct)
        @client = client
      end

      # GET /2/users/:id/followers
      # https://developer.twitter.com/en/docs/twitter-api/users/follows/api-reference/get-users-id-followers
      #
      # Returns paginated list of users following user_id.
      #
      # @param max_results [Integer] Max number of results per peage.
      # @param pagination_token [String] Initial page pagination token.
      # @yield [Array<Twttr::Model::User>] User followers page.
      # @yield [String,NilClass] Pagination token.
      # @return [Array<Twttr::Model::User>] Follower Users.
      def followers(max_results: nil, pagination_token: nil, &block)
        client.followers(id, max_results: max_results, pagination_token: pagination_token, &block)
      end

      # Forwards to Follows#following setting user_id to current user's id.
      #
      # GET /2/users/:id/following
      # https://developer.twitter.com/en/docs/twitter-api/users/follows/api-reference/get-users-id-following
      #
      # Returns paginated list of users followed by user_id.
      #
      # @param max_results [Integer] Max number of results per peage.
      # @param pagination_token [String] Initial page pagination token.
      # @yield [Array<Twttr::Model::User>] Users followed by page.
      # @yield [String,NilClass] Pagination token.
      # @return [Array<Twttr::Model::User>] Users followed.
      def following(max_results: nil, pagination_token: nil, &block)
        client.following(id, max_results: max_results, pagination_token: pagination_token, &block)
      end

      private

      attr_reader :client
    end
  end
end
