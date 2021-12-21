# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'twttr'
  s.version     = '0.0.1'
  s.summary     = 'Twitter API v2 Interface'
  s.description = 'Modular Twitter API interface, initially targeting Twitter API v2'
  s.authors     = ['Roberto Decurnex']
  s.email       = 'roberto@decurnex.io'
  s.files       = [
    'lib/twttr.rb',
    'lib/twttr/client.rb',
    'lib/twttr/client/config.rb',
    'lib/twttr/client/endpoint.rb',
    'lib/twttr/client/endpoint/v2.rb',
    'lib/twttr/client/endpoint/v2/users.rb',
    'lib/twttr/client/endpoint/v2/users/follows.rb',
    'lib/twttr/client/error.rb',
    'lib/twttr/client/oauth_request.rb',
    'lib/twttr/model.rb',
    'lib/twttr/model/user.rb',
  ]
  s.homepage    = 'https://rubygems.org/gems/twttr'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.7'
  s.add_runtime_dependency  'oauth', '~> 0.5.8'
  s.add_runtime_dependency  'uri-query_params', '~> 0.7.2'
  s.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
