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
          USER_BY_USERNAME_PATH = "#{V2::V2_PATH}/users/by/username/%<username>s"
          USER_PATH = "#{V2::V2_PATH}/users/%<user_id>s"

          def me
            response = get(ME_PATH, query_params: { 'user.fields': config.user_fields })
            Model::User.new(response['data'], self)
          end

          def user(user_id)
            response = get(USER_PATH, params: { user_id: user_id },
                                      query_params: { 'user.fields': config.user_fields })
            Model::User.new(response['data'], self)
          end

          def user_by_username(username)
            response = get(USER_BY_USERNAME_PATH, params: { username: username },
                                                  query_params: { 'user.fields': config.user_fields })
            Model::User.new(response['data'], self)
          end

          def users(user_ids)
            response = get(USERS_PATH,
                           query_params: { ids: user_ids.join(','), 'user.fields': config.user_fields })
            response['data'].map { |v| Model::User.new(v, self) }
          end
        end
      end
    end
  end
end

require_relative 'users/follows'
