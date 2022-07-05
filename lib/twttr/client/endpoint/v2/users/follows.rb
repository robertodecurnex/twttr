# frozen_string_literal: true

module Twttr
  class Client
    module Endpoint
      module V2
        module Users
          # Twitter API V2 User Follow related endpoints
          # https://developer.twitter.com/en/docs/twitter-api/users/follows/api-reference
          module Follows
            FOLLOWERS_PATH = "#{Users::USER_PATH}/followers"
            FOLLOWING_PATH = "#{Users::USER_PATH}/following"

            # GET /2/users/:id/followers
            # https://developer.twitter.com/en/docs/twitter-api/users/follows/api-reference/get-users-id-followers
            #
            # Returns paginated list of users following user_id.
            #
            # @param user_id [String] The user ID whose followers you would like to retrieve.
            # @param max_results [Integer] Max number of results per peage.
            # @param pagination_token [String] Initial page pagination token.
            # @yield [Array<Twttr::Model::User>] User followers page.
            # @yield [String,NilClass] Pagination token.
            # @return [Array<Twttr::Model::User>] Follower Users.
            def followers(user_id, max_results: nil, pagination_token: nil, &block) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              response = get(FOLLOWERS_PATH, params: { user_id: user_id },
                                             query_params: {
                                               'user.fields': config.user_fields,
                                               max_results: max_results,
                                               pagination_token: pagination_token
                                             }.compact)

              return [] if response['meta']['result_count'].zero?

              users = response['data'].map { |v| Model::User.new(v, self) }

              pagination_token = response['meta']['pagination_token']

              yield users, pagination_token if block_given?

              return users if pagination_token.nil?

              users + followers(user_id, pagination_token: pagination_token, &block)
            end

            # GET /2/users/:id/following
            # https://developer.twitter.com/en/docs/twitter-api/users/follows/api-reference/get-users-id-following
            #
            # Returns paginated list of users followed by user_id.
            #
            # @param user_id [String] The user ID whose following you would like to retrieve.
            # @param max_results [Integer] Max number of results per peage.
            # @param pagination_token [String] Initial page pagination token.
            # @yield [Array<Twttr::Model::User>] Users followed by page.
            # @yield [String,NilClass] Pagination token.
            # @return [Array<Twttr::Model::User>] Users followed.
            def following(user_id, max_results: nil, pagination_token: nil, &block) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              response = get(FOLLOWING_PATH, params: { user_id: user_id },
                                             query_params: {
                                               'user.fields': config.user_fields,
                                               max_results: max_results,
                                               pagination_token: pagination_token
                                             }.compact)

              return [] if response['meta']['result_count'].zero?

              users = response['data'].map { |v| Model::User.new(v, self) }

              pagination_token = response['meta']['pagination_token']

              yield users, pagination_token if block_given?

              return users if pagination_token.nil?

              users + following(user_id, pagination_token: pagination_token, &block)
            end
          end
        end
      end
    end
  end
end
