# http://say26.com/using-rails-devise-with-ember-js

# What we do here is create an instance of User and then put it into the content variable of CurrentUserController. We then perform typeInjection on all the controllers in our app to give them currentUser variable so that we don't need to set it manually.
# Now, you can access currentUser in any template without needing to set it manually in your controller's needs:

Ember.Application.initializer
  name: 'currentUser'

  initialize: (container) ->
    store = container.lookup('store:main')
    attributes = $('meta[name="current-user"]').attr('content')

    if attributes
      object = store.load(App.User, JSON.parse(attributes))
      user = App.User.find(object.id)
      controller = container.lookup('controller:currentUser').set('content', user)
      container.typeInjection('controller', 'currentUser', 'controller:currentUser')



App.CurrentUserController = Ember.ObjectController.extend
  isSignedIn: (->
    @get('content') != null
  ).property('@content')