# Ember::Beercan

Authorization for Ember with Rails.

Based on: http://avitevet.blogspot.com.es/2013/01/shelving-emberjs-was-authorization-in.html

And http://livsey.org/blog/2012/10/16/writing-a-helper-to-check-permissions-in-ember-dot-js/

Also includes from here: http://livsey.org/blog/2012/02/23/should-your-user-care-about-authentication/

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

## Controllers

* AuthorizationsController (subclass to have your control authorization enabled)
* TokensController (for managing auth tokens)
* GuardedController

### Doorkeeper

Use doorkeeper to setup your API with OAuth protection :)

BeerCan comes with a `GuardedController` you can subclass.

First install doorkeeper:

    $ rails generate doorkeeper:install

Config example (orm):

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

## Securing an Api

See See http://railscasts.com/episodes/352-securing-an-api?view=asciicast

and http://railscasts.com/episodes/353-oauth-with-doorkeeper

Would be nice to get some basic templates in this project that uses some of these approaches.

## Rails Authentication lib integrations

Would also be nice to have support for: https://github.com/heartsentwined/ember-auth-rails

## Sorcery access token

https://github.com/NoamB/sorcery/issues/70

Please see: https://github.com/fzagarzazu/sorcery/commits/access_token

Help bring it into Sorcery gem :)

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
