App.UserSessionNewController = Ember.Controller.extend
  signIn: (email, password) ->
    App.Authentication.userSession.signIn(email, password)
