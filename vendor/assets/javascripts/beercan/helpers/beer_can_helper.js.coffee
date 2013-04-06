App.BeerCan = Ember.Object.extend
  init: (context, property, options) ->
    @context  = context
    @property = property
    @options  = options

  getProp:  ->
    if Ember.isGlobalPath(property)
      Ember.get(property);
    else      
      Ember.get(@path.root, path.path)
  
  path: ->
    @normalizedPath ||= Ember.Handlebars.normalizePath context, property, options.data

# TODO: Refactor!!!
Handlebars.registerHelper 'can', (permissionName, property, options) ->  
  # property is optional, if we've only got 2 arguments then the property contains our options
  if !options
    options = property
    property = null

  context = (options.contexts && options.contexts[0]) || @

  beerCan = App.BeerCan.create context, property, options

  attrs = {}

  # if we've got a property name, get its value and set it to the permission's content
  # this will set the passed in `post` to the content eg:
  # {{#can editPost post}} ... {{/can}}
  
  attrs.content = beerCan.getProp() if property

  # if we've got any options, find their values eg:
  # {{#can createPost project:Project user:App.currentUser}} ... {{/can}}
  for (key in options.hash)
    beerCan.property = options.hash[key]
    attrs[key] = beerCan.getProp()

  # find & create the permission with the supplied attributes
  permission = App.Authorization.Permissions.get permissionName, attrs

  # ensure boundIf uses permission as context and not the view/controller
  # otherwise it looks for 'can' in the wrong place
  options.contexts = null

  # bind it all together and kickoff the observers
  return Ember.Handlebars.helpers.boundIf.call permission, "can", options
