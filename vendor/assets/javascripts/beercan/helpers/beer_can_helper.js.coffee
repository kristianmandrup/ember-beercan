# TODO: Refactor!!!
Handlebars.registerHelper 'can', (permissionName, property, options) ->  
  # property is optional, if we've only got 2 arguments then the property contains our options
  if !options
    options = property
    property = null

  context = (options.contexts && options.contexts[0]) || @

  beerCan = App.BeerCan.create context, property, options

  permissions = App.Authorization.Permissions

  # find & create the permission with the supplied attributes
  permission = permissions.get permissionName, beerCan.attributes

  # ensure boundIf uses permission as context and not the view/controller
  # otherwise it looks for 'can' in the wrong place
  options.contexts = null

  # bind it all together and kickoff the observers
  return Ember.Handlebars.helpers.boundIf.call permission, "can", options
