# Ember::Beercan

Authentication and Authorization tooling for Ember with Rails.

Based on code found in: 
* [ember-rails-devise-token-authentication](http://avitevet.blogspot.com.es/2012/11/ember-rails-devise-token-authentication.html)
* [shelving-emberjs-was-authorization-in](http://avitevet.blogspot.com.es/2013/01/shelving-emberjs-was-authorization-in.html)
* [writing-a-helper-to-check-permissions-in-ember](http://livsey.org/blog/2012/10/16/writing-a-helper-to-check-permissions-in-ember-dot-js/)

And a few other places (see below)

This gem includes both coffeescript assets and Rails controller code to get you started ;)

The Rails controller code depends on the [cancan](https://github.com/ryanb/cancan) and [rails-api](https://github.com/rails-api/rails-api) gems.

## Note

This gem is a work in progress... please help improve it!

Also help improve the README and usage instructions.

## Installation

Add this line to your application's Gemfile:

    gem 'ember-beercan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ember-beercan

## Usage

Add an `ApiUrl` hash with some Rails authorization routes info stored:

```erb
# routes/api_url.js.coffee.erb

<% url_helpers = MyApp::Application.routes.url_helpers %>
App.Routes.ApiUrl = {
  tokens_path: '<%= url_helpers.tokens_path %>',
  authorization_path: '<%= url_helpers.authorization_path %>'
};
```

Usually the `authorization_path` will point to `AuthorizationsController#show` and the `tokens_path` to `TokensController` `#create` and `#destroy` methods.

## Ember Auth toolset

Simply add the following to your script manifest.

```coffeescript
#= require beercan
```

Or alternatively include individual "modules"

```coffeescript
#= require beercan/authorization
```

Or with more control: `#= require_tree beercan/authorization` or 
`#= require beercan/authorization/authorizer`

Now add permissions:

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

See [writing-a-helper-to-check-permissions-in-ember](http://livsey.org/blog/2012/10/16/writing-a-helper-to-check-permissions-in-ember-dot-js/) for more instructions.

Alternatively use the `App.Authorization.Authorizer#authorize` method, which should call the `AuthorizationsController` on the server, and respond with the result of a can? check there, so that the server is responsible for authorization and has the rules there...

This approach is sketched out here: [shelving-emberjs-was-authorization-in](http://avitevet.blogspot.com.es/2013/01/shelving-emberjs-was-authorization-in.html)

There are also some nice ideas presented in this [gist](https://gist.github.com/ivanvanderbyl/4560416) about how to integrate with *cancan* permissions.

You must have a `currentUser` on the controller for permissions to work.
For this a `App.CurrentUserController` is included. On this controller you can set the `currentUserPath` property to the path of your server API that returns the current user.
It might be useful to return a `Guest` user, in case no user is logged in.

A `CurrentUserController` with `currentUser` functionality, is made available in all controllers using the `Ember.Application.initializer`, named 'currentUser'.

The mixin module `BeerCan::FindMe` can be included in a `UsersController` on the server, to add the `me` method ('users/me' path). This method tries to respond with a User (Serialized as JSON), by calling `User.find_by token_hash` where token is assumed to be passed as a `:authenticity_token` (or similar) parameter from the client (using Ajax).

You can customize the lookup-field used for the token on the user, by overriding the `token_hash` method like this (default field is `token:`)

```ruby
class UsersController
  include BeerCan::FindMe

  protected

  def token_hash
    {auth_token: authenticity_token}
  end
end
```

### App.Authentication.UserSession

Simple sign in/out

* signedIn (is the user signed in?)
* signIn
* signOut

## App.Authorization.Authorizer

`Autorizer.create(action: 'update', object: post).authorize`

## App.Authorization.Permissions

`App.Authorization.Permissions.register(name, type)`

## App.UserSessionNewController

`App.UserSessionNewController.signIn(email, password)`

This can be used for simple (old school) email/password login. The server should generate an auth token on successful login, which is then communicate between client and server until it expires, which then requires a new login.

## App.Routes.SigninMatcher

`App.Routes.SigninMatcher.map(match)` can be used to add signin routes:

* `match('/signIn').to('userSessionNew')`
* `match('/users/:user_id').to('user')`

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

BeerCan comes with a `GuardedController` you can subclass which include basic DoorKeeper functionality to return the current_user based on the doorkeeper token.

Simply subclass `GuardedBaseController` for controllers you want guarded by doorkeeper!
Then use the `doorkeeper_for` macro to customize for which actions etc. it should apply

Default is for any xhr (AJAX) request received: 

`doorkeeper_for :all, :if => lambda { request.xhr? }`

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

## Auth lib integrations (future)

Would be nice to have built-in support for: [ember-auth-rails](https://github.com/heartsentwined/ember-auth-rails) and [pundit](https://github.com/elabs/pundit)

## Global app state

Note: to set global app state, use this tip: https://github.com/emberjs/ember.js/issues/1780

```javascript
# fired no matter what route is hit on application launch.
App.ApplicationRoute = Ember.Route.extend({
  setupController: function(controller, model){
    controller.loadCompanyName();
    this._super(controller, model);
  }
});
```

## User Serializer with authorization

This approach might also be useful...

https://gist.github.com/ivanvanderbyl/4560416

```ruby
class ApplicationController < ActionController::Base
   helper_method :current_permission_json

   delegate :can_update, :can_delete, :can_manage, to: :current_permission

   def current_permission_json
       UserSerializer.new([can_update, can_delete, can_manage], :scope => current_user.role, :root => false).to_json
   end
end

class UserSerializer < ActiveModel::Serializer
  attributes :can_update, :can_delete, :can_manage

  def attributes
    hash =  super
    #if scope.admin?
    if scope.role? :admin
      can_manage
    else
      can_update
    if user.role?(:author)
      can_delete, Article do |article|
        article.try(:user) == user
      end
    end       
  end

  private

  def can_manage
     Ability.new.can?(:manage, all)
  end

  def can_update
    # `scope` is current_user
    Ability.new.can?(:update, object)
  end

  def can_delete
    Ability.new.can?(:delete, object)
  end
end
```

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
