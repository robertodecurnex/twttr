# frozen_string_literal: true

module Twttr
  class Client
    #  Client rrrors namesace
    module Error
      #  HTTP related errors
      class HTTPError < StandardError
        def initialize(msg = 'HTTP Error')
          super
        end
      end
    end
  end
end
