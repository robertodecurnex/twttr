# Twttr
Twitter API v2 Interface

[![example workflow](https://github.com/robertodecurnex/twttr/actions/workflows/test.yml/badge.svg)](https://github.com/robertodecurnex/twttr/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/twttr.svg)](https://rubygems.org/gems/twttr)
[![Coverage Status](https://coveralls.io/repos/github/robertodecurnex/twttr/badge.svg?branch=master)](https://coveralls.io/github/robertodecurnex/twttr?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/22a43fe43bc5a038854e/maintainability)](https://codeclimate.com/github/robertodecurnex/twttr/maintainability)
-----

## Summery
Modular Twitter API interface, initially targeting Twitter API v2

## Examples

### Config
```ruby
# Creating a Client using OAuth 1.0a User context
client = Twttr::Client.new(user_id) do |config|
  # App credentials
  config.consumer_key        = "consumer_key"
  config.consumer_secret     = "consumer_secret"

  # User credentials
  config.access_token        = "access_token"
  config.access_token_secret = "access_secret"

  # Default user fields
  # https://developer.twitter.com/en/docs/twitter-api/data-dictionary/object-model/user
  config.user_fields         = %w(id, name, username)
end #=> #<Twttr::Client>
```

### Client
```ruby
# Twttr::Client#me
client.me #=> #<Twttr::Model::User>

#Twttr::Client#user(:user_id)
client.user("user_id") #=> #<Twttr::Model::User>

#Twttr::Client#user_by_username(:username)
client.user_by_username("username") #=> #<Twttr::Model::User>

#Twttr::Client#users(:user_ids)
client.users(["user_id_1", "user_id_2"]) #=> [#<Twttr::Model::User>]

# Twttr::Client#Followers
client.followers("user_id") == client.user("user_id").followers

# Twttr::Client#Following
client.following("user_id") == client.user("user_id").following
```
### User
```ruby
# Twttr::Model::User#followers
#
# Yields each page of users
user.followers do |users, pagination_token|
  users #=> [#<Twttr::Model::User>]
end #=> [#<Twttr::Model::User>]

# Follower users
user.followers #=> [#<Twttr::Model::User>]

# Twttr::Model::User#following
#
# Yields each page of users
user.following do |users, pagination_token|
  users #=> [#<Twttr::Model::User>]
end #=> [#<Twttr::Model::User>]

# Followed users
user.following #=> [#<Twttr::Model::User>]
```

## Implemented Endpoints

### Authentication

|Type       |Initial Release  |Implemented?       |
|:---       |:---:            |:---:              |
|OAuth 1.0a |v0.0.5           |:white_check_mark: |
|OAuth 2.0  |-                |-                  |

### Users

#### Users Lookup

|Endpoint                           |Initial Release  |Implemented?       |
|:---                               |:---:            |:---:              |
|GET /2/users                       |v0.0.5           |:white_check_mark: |
|GET /2/users/:id                   |v0.0.5           |:white_check_mark: |
|GET /2/users/by                    |v0.0.6           |:white_check_mark: |
|GET /2/users/by/username/:username |v0.0.5           |:white_check_mark: |
|GET /2/users/me                    |v0.0.5           |:white_check_mark: |

#### Follows

|Endpoint                                                   |Initial Release  |Implemented?       |
|:---                                                       |:---:            |:---:              |
|GET /2/users/:id/following                                 |v0.0.5           |:white_check_mark: |
|GET /2/users/:id/followers                                 |v0.0.6           |:white_check_mark: |
|POST /2/users/:id/following                                |-                |-                  |
|DELETE /2/users/:source_user_id/following/:target_user_id  |-                |-                  |
