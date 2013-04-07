# Ember::Beercan

Authentication and Authorization tooling for Ember with Rails.

Based on code found in: 
* [ember-rails-devise-token-authentication](http://avitevet.blogspot.com.es/2012/11/ember-rails-devise-token-authentication.html)
* [shelving-emberjs-was-authorization-in](http://avitevet.blogspot.com.es/2013/01/shelving-emberjs-was-authorization-in.html)
* [writing-a-helper-to-check-permissions-in-ember](http://livsey.org/blog/2012/10/16/writing-a-helper-to-check-permissions-in-ember-dot-js/)

This gem includes both coffeescript assets and Rails controller code to get you started ;)

The Rails controller code depends on the [cancan](https://github.com/ryanb/cancan) and [rails-api](https://github.com/rails-api/rails-api) gems.

## Note

This gem is a work in progress... please help improve it!

## Installation

Add this line to your application's Gemfile:

    gem 'ember-beercan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ember-beercan

## Usage

Add an `ApiUrl` hash with some Rails authorization info stored:

```erb
# routes/api_url.js.coffee.erb

<% url_helpers = MyApp::Application.routes.url_helpers %>
App.Routes.ApiUrl = {
  tokens_path: '<%= url_helpers.tokens_path %>',
  authorization_path: '<%= url_helpers.authorization_path %>'
};
```

## Ember Auth toolset

Simply add the following to your script manifest.

```coffeescript
#= require beercan
```

Or alternatively include individual "modules"

```coffeescript
#= require beercan/authorization
```

Add permissions:

```javascript
App.Permissions.register("createPost", App.Permission.extend({
  can: function() {
    return this.get("currentUser.isAdmin");
  }.property("currentUser.isAdmin")
}));

App.Permissions.register("editPost", App.Permission.extend({
  can: function(){
    return this.get("currentUser.isAdmin") || this.get("content.author.id") == this.get("currentUser.id");
  }.property("currentUser.isAdmin", "content")
}));
```

You must also have a currentUser at `App.currentUser` for permissions to work.

See [writing-a-helper-to-check-permissions-in-ember](http://livsey.org/blog/2012/10/16/writing-a-helper-to-check-permissions-in-ember-dot-js/) for more instructions.

## Controllers

* AuthorizationsController (subclass to have your control authorization enabled)
* TokensController (for managing auth tokens)
* GuardedController


The `TokensController` uses a `Tokener`. Currently tokeners are provided for Sorcery and Devise:
* `SorceryTokener`
* `DeviseTokener`

You can implement this simple interface for whichever Auth token solution you are using.

```ruby
class SorceryTokener
  attr_reader :user, :controller

  def initialize user, controller = nil
    @user = user
    @controller = controller
  end

  def token    
    user.token
  end

  def reset_token
    controller.destroy_access_token
  end
  
  def authenticate_token
    # should fire after_login hook, which performs token authentication
    controller.login_from_access_token
  end
end
```

Note: This version of the [sorcery](https://github.com/kristianmandrup/sorcery) gem, provides an `AccessToken` module you can use as an alternative to Devise. See [access_token](https://github.com/fzagarzazu/sorcery/commits/access_token)

To select a tokener, you can use the `tokener_for` macro, which expects a tokener class of the form `<name>Tokener`

```ruby
class TokensController < APIController
  tokener_for :sorcery
end
```

### Doorkeeper

Use doorkeeper to setup your API with OAuth protection :)

BeerCan comes with a `GuardedController` you can subclass.

First install doorkeeper:

    $ rails generate doorkeeper:install

Config example (mongoid):

```ruby
# initializers/doorkeeper.rb
Doorkeeper.configure do
  orm :mongoid2 # or :mongoid3, :mongo_mapper

  # et resource owner, typically a User
  resource_owner_authenticator do
    User.find(session[:current_user_id]) || redirect_to(login_url)
  end  
end
```

For mongoid, make sure to create indexes!

    $ rake db:mongoid:create_indexes

See [wiki](https://github.com/applicake/doorkeeper/wiki) for more option and info 

Currently, the BeerCan coffeescript auth modules are not setup to use the `GuardedController`.Please help out implementing this integration ;)

## Securing an Api

See [railscast: securing an api](http://railscasts.com/episodes/352-securing-an-api?view=asciicast) for a walk-through of what is required...

## Authentication lib integrations

Would also be nice to have support for: https://github.com/heartsentwined/ember-auth-rails

## Rails assets config

http://guides.rubyonrails.org/asset_pipeline.html

For faster asset precompiles, you can partially load your application by setting `config.assets.initialize_on_precompile` to `false` in `config/application.rb`, though in that case templates cannot see application objects or methods. *Heroku requires this to be false.*

`config.assets.initialize_on_precompile = false`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
