App.Authorization.Authorizer = Ember.Object.extend
  action: ''
  object: null
  response: 401
  urlBase: ApiUrl.authorization_path

  can : (-> 
      return (this.get('response') == 200)
  ).property('response')

  authorize: ->
    # if object is an instance, include the id in the query params
    # otherwise, just include the class name
    obj = this.get('object')
    cName = obj.toString()
    id = null
    if Ember.typeOf(obj) == "instance"
      # cname looks something like "<namespace.name:embernumber>"
      # turn it into "name"
      cName = cName.split(':')[0].split('.')[1]
      id = obj.get('id')

    $.ajax 
       url : "#{this.get('urlBase')}.json"
       context : this
       type : 'GET'
       data : 
          action : this.get('action')
          cName : cName
          id : id

       complete : (data, textStatus, xhr) ->
          this.set('response', data.status)

    return this.get('can')