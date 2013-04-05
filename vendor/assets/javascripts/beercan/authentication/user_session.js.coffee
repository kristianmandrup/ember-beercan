App.Authentication.UserSession = Ember.Object.extend
   auth_token : null
   urlBase : ApiUrl.tokens_path
   errorMsg : null

   signedIn : (-> 
      return (this.get('auth_token') != null)
   ).property('auth_token')

   signIn : (email, password) ->
      $.ajax 
         url : "#{this.get('urlBase')}.json"
         context : App.Authentication.userSession
         type : 'POST'
         data : 
            email : email
            password : password

         success : (data) ->
            this.set('auth_token', data.token)

         error : (data) ->
            this.errorMsg = "there was an error"
         

      return this.get('auth_token')
   
   signOut : ->
      $.ajax
         url : "#{this.get('urlBase')}/#{this.get('auth_token')}.json"
         context : App.Authentication.userSession
         type : 'DELETE'
         success : (data) ->
            this.set('auth_token', null)
         
         error : (data) -> 
           this.errorMsg = "there was an error"
      return null

App.Authentication.userSession = App.Authentication.UserSession.create()