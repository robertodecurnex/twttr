# frozen_string_literal: true

module Twttr
  class Client
    module Endpoint
      module V2
        #  Twitter API V2 Users related endpoints
        #  https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference
        module Users
          ME_PATH = "#{V2::V2_PATH}/users/me"
          USERS_PATH = "#{V2::V2_PATH}/users"
          USERS_BY_PATH = "#{V2::V2_PATH}/users/by"
          USER_BY_USERNAME_PATH = "#{V2::V2_PATH}/users/by/username/%<username>s"
          USER_PATH = "#{V2::V2_PATH}/users/%<user_id>s"

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

          # GET /2/users/me
          # https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference/get-users-me
          #
          # Returns current authenticated user
          #
          # @return [Twttr::Model::User] Current user.
          def me
            response = get(ME_PATH, query_params: { 'user.fields': config.user_fields })
            Model::User.new(response['data'], self)
          end

          # GET /2/users/:id
          # https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference/get-users-id
          #
          # Returns target user by id
          #
          # @param user_id [String] Traget user id.
          # @return [Twttr::Model::User] Target user.
          def user(user_id)
            response = get(USER_PATH, params: { user_id: user_id },
                                      query_params: { 'user.fields': config.user_fields })
            Model::User.new(response['data'], self)
          end

          # GET /2/users/by/username/:username
          # https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference/get-users-by-username-username
          #
          # Returns target user by username
          #
          # @param username [String] Traget username.
          # @return [Twttr::Model::User] Target user.
          def user_by_username(username)
            response = get(USER_BY_USERNAME_PATH, params: { username: username },
                                                  query_params: { 'user.fields': config.user_fields })
            Model::User.new(response['data'], self)
          end

          # GET /2/users
          # https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference/get-users
          #
          # Returns target users by id
          #
          # @param user_ids [Array<String>] Traget user ids.
          # @return [Array<Twttr::Model::User>] Target users.
          def users(user_ids)
            response = get(USERS_PATH,
                           query_params: { ids: user_ids.join(','), 'user.fields': config.user_fields })
            response['data'].map { |v| Model::User.new(v, self) }
          end

          # GET /2/users/by
          # https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference/get-users-by
          #
          # Returns target users by username
          #
          # @param usernames [Array<String>] Traget usernames.
          # @return [Array<Twttr::Model::User>] Target users.
          def users_by(usernames)
            response = get(USERS_BY_PATH,
                           query_params: { usernames: usernames.join(','), 'user.fields': config.user_fields })
            response['data'].map { |v| Model::User.new(v, self) }
          end
        end
      end
    end
  end
end

require_relative 'users/follows'
