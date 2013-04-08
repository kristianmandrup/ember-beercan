App.CurrentUserController = Ember.ObjectController.extend
  content: null
  currentUserPath: '/users/me'

  isSignedIn: (->
    @get('content') != null
  ).property('@content')

  # http://stackoverflow.com/questions/9618395/strategy-to-retrieve-the-current-user
  retrieveCurrentUser: ->
    controller = @
    Ember.$.getJSON(@currentUserPath, (data) ->
      App.store.load(App.User, data)
      var currentUser = App.store.find(data.id)
      controller.set 'content', currentUser
    )
  

# http://say26.com/using-rails-devise-with-ember-js
Ember.Application.initializer
  name: 'currentUser'

  initialize: (container) ->
    store = container.lookup('store:main')
      user = App.User.find(object.id)
      controller = container.lookup('controller:currentUser')  
      container.typeInjection('controller', 'currentUser', 'controller:retrieveCurrentUser')

