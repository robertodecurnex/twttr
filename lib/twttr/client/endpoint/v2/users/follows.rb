# frozen_string_literal: true

module Twttr
  class Client
    module Endpoint
      module V2
        module Users
          # Twitter API V2 User Follow related endpoints
          # https://developer.twitter.com/en/docs/twitter-api/users/follows/api-reference
          module Follows
            FOLLOWING_PATH = "#{Users::USER_PATH}/following"

            # GET /2/users/:id/following
            # https://developer.twitter.com/en/docs/twitter-api/users/follows/api-reference/get-users-id-following
            #
            # @param user_id [String] The user ID whose following you would like to retrieve.
            # @param max_results [Integer] Max number of results per peage.
            # @param pagination_token [String] Initial page pagination token.
            # @yield [Array<Twttr::Model::User>] Users followed by page.
            # @return [Array<Twttr::Model::User>] Users followed.
            # @return [String,NilClass] Pagination token.
            def following(user_id, max_results: nil, pagination_token: nil, &block) # rubocop:disable Metrics/MethodLength
              response = get(FOLLOWING_PATH, params: { user_id: user_id },
                                             query_params: {
                                               'user.fields': config.user_fields,
                                               max_results: max_results,
                                               pagination_token: pagination_token
                                             }.compact)

              return [], nil if response['meta']['result_count'].zero?

              users = response['data'].map { |v| Model::User.new(v, self) }

              pagination_token = response['meta']['pagination_token']

              return users, pagination_token unless block_given?

              yield users, pagination_token

              following(user_id, pagination_token, &block) unless pagination_token.nil?
            end
          end
        end
      end
    end
  end
end
