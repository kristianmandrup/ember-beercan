App.UserSessionNewController = Ember.Controller.extend
  signIn: (email, password) ->
    EmberDeviseExample.userSession.signIn(email, password)
