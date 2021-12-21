# frozen_string_literal: true

module Twttr
  class Client
    module Endpoint
      module V2
        V2_PATH = '/2'
      end
    end
  end
end

require_relative 'v2/users'
