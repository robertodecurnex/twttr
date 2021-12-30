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

      def following(max_results: nil, pagination_token: nil, &block)
        client.following(id, max_results: max_results, pagination_token: pagination_token, &block)
      end

      private

      attr_reader :client
    end
  end
end
