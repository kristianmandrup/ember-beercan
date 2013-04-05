App.Routes.SigninMatcher = Ember.Object.extend
  map: (match) ->
    match('/signIn').to('userSessionNew')
    match('/users/:user_id').to('user')

App.Routes.signinMatcher = App.Routes.SigninMatcher.create()