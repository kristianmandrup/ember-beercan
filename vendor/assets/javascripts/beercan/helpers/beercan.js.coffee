App.BeerCan = Ember.Object.extend
  init: (context, property, options) ->
    @context  = context
    @property = property
    @options  = options
    @attrs    = {}    

  getProp:  ->
    if Ember.isGlobalPath(property)
      Ember.get(property);
    else      
      Ember.get(@path.root, path.path)

  attributes: ->
    # if we've got a property name, get its value and set it to the permission's content
    # this will set the passed in `post` to the content eg:
    # {{#can editPost post}} ... {{/can}}
    
    @attrs.content = @getProp() if property

    # if we've got any options, find their values eg:
    # {{#can createPost project:Project user:App.currentUser}} ... {{/can}}
    for (key in @options.hash)
      @property = @options.hash[key]
      @attrs[key] = @getProp()
    # return the attributes
    @attrs

  
  path: ->
    @normalizedPath ||= Ember.Handlebars.normalizePath context, property, options.data
