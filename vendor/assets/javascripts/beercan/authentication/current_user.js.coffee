App.CurrentUserController = Ember.ObjectController.extend
  content: null,

  isSignedIn: (->
    @get('content') != null
  ).property('@content'),

  # http://stackoverflow.com/questions/9618395/strategy-to-retrieve-the-current-user
  retrieveCurrentUser: ->
    var controller = @
    Ember.$.getJSON('/users/me', (data) ->
      App.store.load(App.User, data)
      var currentUser = App.store.find(data.id)
      controller.set 'content', currentUser
    )

# http://say26.com/using-rails-devise-with-ember-js
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

