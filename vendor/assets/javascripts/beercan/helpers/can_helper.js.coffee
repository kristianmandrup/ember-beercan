Ember.Handlebars.registerBoundHelper 'can', (object, options) ->

    permission = EmberDeviseExample.Authorization.create
        action: options.hash.action
        object: object

    permission.authorize()

    options.contexts = [permission]

    Ember.Handlebars.helpers.boundIf.call(permission, "can", options)

# http://livsey.org/blog/2012/10/16/writing-a-helper-to-check-permissions-in-ember-dot-js/
Handlebars.registerHelper 'canI', (permissionName, property, options) ->
  permission = Ember.Object.create
    canI: ( ->
      return true;
    ).property()

  # wipe out contexts so boundIf uses `this` (the permission) as the context
  options.contexts = null

  Ember.Handlebars.helpers.boundIf.call permission, "canI", options
