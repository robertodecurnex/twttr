# frozen_string_literal: true

module Twttr
  class Client
    # Client Configuration
    class Config
      attr_accessor :consumer_key, :consumer_secret, :access_token, :access_token_secret
      attr_reader :user_fields

      def user_fields=(fields)
        @user_fields = fields.join(',')
      end
    end
  end
end
