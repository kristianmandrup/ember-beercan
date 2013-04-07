App.Authorization.Authorizer = Ember.Object.extend
  action:   ''
  object:   null
  response: 401
  urlBase:  ApiUrl.authorization_path

  can: (-> 
    @allowed 
  ).property('response')

  authorize: ->        
    $.ajax 
      url:      @url
      context:  @
      type:     'GET'
      data: 
        id:     @id
        action: @get 'action'
        cName:  @cName

      complete : (data, textStatus, xhr) ->
        set_allowed data

    @get 'can'

  set_allowed: (data) ->
    @set 'response', data.status

  allowed: ->
    @get('response') == 200

  url: ->
    "#{@get('urlBase')}.json"

  obj: ->
    @get 'object'

  id: ->
    @obj.get 'id'      

  # if object is an instance, include the id in the query params
  # otherwise, just include the class name
  cName: -> 
    return @cname if @cname
    name = @obj.toString()
    # cname looks something like "<namespace.name:embernumber>"
    # turn it into "name"
    @cname = Ember.typeOf(obj) == "instance" ? @normalize(name) : name

  normalize: (name) ->
    name.split(':')[0].split('.')[1]