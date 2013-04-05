# Ember::Beercan

Authorization for Ember with Rails.

Based on: http://avitevet.blogspot.com.es/2013/01/shelving-emberjs-was-authorization-in.html

## Note

Work in progress... please help improved it!

## Installation

Add this line to your application's Gemfile:

    gem 'ember-beercan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ember-beercan

## Usage

Add an ApiUrl hash with some Rails authorization info stored:

```erb
# routes/api_url.js.coffee.erb

<% url_helpers = MyApp::Application.routes.url_helpers %>
App.Routes.ApiUrl = {
  tokens_path: '<%= url_helpers.tokens_path %>',
  authorization_path: '<%= url_helpers.authorization_path %>'
};
```

## Auth lib integrations

See http://railscasts.com/episodes/352-securing-an-api?view=asciicast

## Sorcery access token

https://github.com/NoamB/sorcery/issues/70

Please see: https://github.com/fzagarzazu/sorcery/commits/access_token

Help bring it into Sorcery gem :)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
