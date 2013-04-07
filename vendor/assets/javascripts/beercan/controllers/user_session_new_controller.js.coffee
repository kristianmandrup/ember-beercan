App.UserSessionNewController = Ember.Controller.extend
  signIn: (email, password) ->
    App.userSession.signIn(email, password)
