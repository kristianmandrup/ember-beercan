App.CurrentUserController = Ember.ObjectController.extend
  content: null
  currentUserPath: '/users/me'
  userType: App.User

  isSignedIn: (->
    @get('content') != null
  ).property('@content')

  # http://stackoverflow.com/questions/9618395/strategy-to-retrieve-the-current-user
  retrieveCurrentUser: ->
    controller = @
    Ember.$.getJSON(@currentUserPath, (data) ->
      App.store.load(@userType, data)
      var currentUser = App.store.find(data.id)
      controller.set 'content', currentUser
    )

# http://say26.com/using-rails-devise-with-ember-js
Ember.Application.initializer
  name: 'currentUser'

  initialize: (container) ->
    container.typeInjection('controller', 'currentUser', 'controller:currentUser')

